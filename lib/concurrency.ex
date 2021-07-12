defmodule Concurrency do
  use Application

  def start(_type, _args) do
    Concurrency.GenCounterSupervisor.start_link()
  end

  def hello, do: :world
end
