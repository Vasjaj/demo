defmodule DemoWeb.FibController do
  use DemoWeb, :controller

  def fib(conn, params) do
    result = Demo.Fib.fib(String.to_integer(params["number"]))
    json(conn, %{result: result})
  end
end
