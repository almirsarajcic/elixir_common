defmodule SkafolderTesterWeb.TestPlug do
  @behaviour Plug
  import Phoenix.ConnTest

  @spec dispatch((Plug.Conn.t() -> Plug.Conn.t())) :: Plug.Conn.t()
  def dispatch(fun) do
    code =
      fun
      |> :erlang.term_to_binary()
      |> Base.url_encode64(padding: false)

    dispatch(build_conn(), SkafolderTesterWeb.Endpoint, :get, "/test_execute/#{code}")
  end

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _opts) do
    with %Plug.Conn{method: "GET", path_info: ["test_execute", code]} <- conn do
      fun =
        code
        |> Base.url_decode64!(padding: false)
        |> :erlang.binary_to_term()

      fun.(conn)
    end
  end
end
