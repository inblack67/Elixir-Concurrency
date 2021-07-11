defmodule Concurrency.Supervisor do
  use Supervisor

  alias Concurrency.Chat

  # supervisor allows us to create processes which watch are processes and if a process dies, supervisor will try to restart it

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    # if one of our processes dies => respawns
    # :one_for_all => if one dies => restart all
    # :rest_for_one => restart it and any process activated after it

    children = [
      {Chat, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
