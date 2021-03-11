defmodule RabtaNkWeb.UserController do
  use RabtaNkWeb, :controller
  require Logger

  @build_year DateTime.utc_now().year
  @validity_years 31

  def show(conn, _params) do
    render( conn, "user.json", %{name: "hi back"})
  end

  defp check_time() do
    unless DateTime.utc_now().year >= @build_year do
      raise """
      It doesn't look like the clock has been set. Check that `nerves_time` is running
      or something else is providing time.
      """
    end
  end

  def sign(conn, params) do
    check_time()

    Logger.debug "Params: #{inspect params}"

    # Extract CSR
    csr_str = case params do
      %{"csr_str" => csr_str} -> csr_str
      _ -> Logger.error "csr_str not found in params"
    end
    device_sn = case params do
      %{"device_sn" => device_sn} -> device_sn
      _ ->
        Logger.error "device_sn not found in params"
        atecc508a_serial_number = :crypto.strong_rand_bytes(9)
    end
    manufacturer_sn = case params do
      %{"manufacturer_sn" => manufacturer_sn} -> manufacturer_sn
      _ ->
        Logger.error "manufacturer_sn not found in params"
        "AERQE3ADROUXJ3Q"
    end
    Logger.debug "manufacturer_sn:"
    Logger.debug "#{inspect manufacturer_sn}"
#    %{"csr_str" => csr_str, "device_sn" => device_sn} = params

    csr = X509.CSR.from_pem!(csr_str)

    cert_name="signer-ca-2"
    signer_key = File.read!("certs/#{cert_name}.key") |> X509.PrivateKey.from_pem!();true
    signer_cert = File.read!("certs/#{cert_name}.cert") |> X509.Certificate.from_pem!();true

    device_public_key = csr |> X509.CSR.public_key()

    device_cert =
      ATECC508A.Certificate.new_device(
        device_public_key,
        device_sn,
        manufacturer_sn,
        signer_cert,
        signer_key
      )

    device_cert_pem = X509.Certificate.to_pem(device_cert)
    render( conn, "sign.json", device_cert: device_cert_pem)
  end

  def handle( conn, params ) do
    json(conn, %{body: params})
    render( conn, "handle.json", %{device_cert: "device_cert"})
  end

  def psthandle( conn, params ) do
    response = %{"Name" => "Abc"}
    json(conn, %{body: response})
#    render( conn, "handle.json", %{device_cert: "device_cert"})
  end

end
