defmodule RabtaNkWeb.UserController do
  use RabtaNkWeb, :controller
  require Logger

  def show(conn, _params) do
    render( conn, "user.json", %{name: "hi back"})
  end

  def sign(conn, params) do
    Logger.debug "Params: #{inspect params}"

    # Extract CSR
    %{"csr_str" => csr_str} = params
    csr = X509.CSR.from_pem!(csr_str)
#    Logger.debug "csr: #{inspect csr}"

    # Load Signer CA cert & private key
    cert_name="signer-ca-2"
    signer_key = File.read!("certs/#{cert_name}.key") |> X509.PrivateKey.from_pem!();true
    signer_cert = File.read!("certs/#{cert_name}.cert") |> X509.Certificate.from_pem!();true
    #    Logger.info "signer_key: #{inspect signer_key}"
    #    Logger.info "signer_cert: #{inspect signer_cert}"

    # Sign CSR
    subject = X509.CSR.subject(csr)
    device_cert = csr |> X509.CSR.public_key() |> X509.Certificate.new( subject, signer_cert, signer_key )

    response = %{device_cert: device_cert}
#    json(conn, response)
    device_cert = Tuple.to_list( device_cert )
    render( conn, "sign.json", device_cert: device_cert)
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
