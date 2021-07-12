defmodule Concurrency.GenCounterSupervisor do
  use Supervisor

  alias Concurrency.GenCounter

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    children = [
      {GenCounter.Producer, [0]},
      {GenCounter.ProducerConsumer, [0]},
      Supervisor.child_spec({GenCounter.Consumer, []}, id: :c1),
      Supervisor.child_spec({GenCounter.Consumer, []}, id: :c2),
      Supervisor.child_spec({GenCounter.Consumer, []}, id: :c3),
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
