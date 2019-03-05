defmodule PgQueue.QueueSupervisor do
  use DynamicSupervisor

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def start_queue(event_name) do
    queue_name = {:via, Registry, {PgQueue.Registry, event_name}}
    DynamicSupervisor.start_child(__MODULE__, PgQueue.Queue.child_spec(event_name, name: queue_name))
  end

  def stop_queue(event_name) do
    case Registry.lookup(PgQueue.Registry, event_name) do
      [] ->
        {:error, :not_found}
      [{queue, _}] ->
        DynamicSupervisor.terminate_child(__MODULE__, queue)
        Registry.unregister(PgQueue.Registry, event_name)
    end
  end

  @impl true
  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
