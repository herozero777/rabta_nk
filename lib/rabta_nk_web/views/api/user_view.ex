defmodule RabtaNkWeb.UserView do
  use RabtaNkWeb, :view
  alias RabtaNkWeb.UserView

  def render("user.json", %{name: name}) do
    %{
      data: %{
        result: name
      }
    }
  end

#  def render("sign.json", %{device_cert: device_cert}) do
  def render("sign.json", %{device_cert: device_cert}) do
    # Sol 1
#    Poison.encode!( %{ data: device_cert } )
    # Sol 2
#    %{ data: %{device_cert: device_cert} }
    # Sol 3
#    %{data: render_one(device_cert, UserView, "ca_certificate.json")}
    %{data: render_one(device_cert, UserView, "device_certificate.json")}
  end

  def render("handle.json", %{device_cert: dc} ) do
    %{
      data: %{
        result: "me"
      }
    }
  end

  def render("device_certificate.json", %{device_certificate: device_certificate}) do
    %{
      serial: device_certificate.serial,
      not_before: device_certificate.not_before,
      not_after: device_certificate.not_after
    }
  end
  def render("ca_certificate.json", %{ca_certificate: ca_certificate}) do
    %{
      serial: ca_certificate.serial,
      not_before: ca_certificate.not_before,
      not_after: ca_certificate.not_after,
      description: ca_certificate.description
    }
  end

end
