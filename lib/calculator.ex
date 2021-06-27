defmodule Concurrency.Calculator do
  def start, do: spawn(fn -> loop(0) end)

  defp loop(current_value) do
    new_value =
      receive do
        {:value, client_id} ->
          send(client_id, {:response, current_value})
          current_value

        {:add, value} ->
          current_value + value

        {:subtract, value} ->
          current_value - value

        {:multiply, value} ->
          current_value * value

        {:divide, value} ->
          current_value / value

        invalid_request ->
          IO.puts("Invalid request #{inspect(invalid_request)}")
          current_value
      end

    loop(new_value)
  end

  # server_id => on which the calculator process is running
  def get_value(server_id) do
    # self => sharing current state of the process => loop func
    send(server_id, {:value, self()})

    receive do
      {:response, value} ->
        value
    after
      5000 ->
        IO.puts("Receive block timeout")
    end
  end

  def add(server_id, value) do
    send(server_id, {:add, value})
  end

  def subtract(server_id, value) do
    send(server_id, {:subtract, value})
  end

  def multiply(server_id, value) do
    send(server_id, {:multiply, value})
  end

  def divide(server_id, value) do
    send(server_id, {:divide, value})
  end
end
