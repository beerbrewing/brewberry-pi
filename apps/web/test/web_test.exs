defmodule WebTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @moduletag :capture_log

  @opts Brewberry.Router.init([])

  def request(method, path, body \\ nil) do
    conn(method, path, body)
    |> put_req_header("content-type", "application/json")
    |> Brewberry.Router.call(@opts)
  end

  test "/ returns index file" do
    conn = request(:get, "/")

    assert conn.state == :set
    assert conn.status == 301
    assert get_resp_header(conn, "location") === ["/index.html"]
  end

  test "returns index file" do
    conn = request(:get, "/index.html")

    assert conn.state == :sent
    assert conn.status == 200
    assert String.contains?(conn.resp_body, "<title>Brewberry &pi;</title>")
  end

  test "reads temperature" do
    conn = request(:get, "/temperature")

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "{\"mash-temperature\":12}"
  end

  test "set temperature" do
    conn = request(:post, "/temperature", "{\"set\":42}")

    assert conn.params == %{"set" => 42}
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "{\"mash-temperature\":42}"
  end

#  xtest "get logging data" do
#    conn = request(:get, "/logger")
#
#    assert conn.state == :sent
#    assert conn.status == 200
#    assert conn.resp_body == "{\"mash-temperature\":42}"
#  end

end
