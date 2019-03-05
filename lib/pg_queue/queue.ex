defmodule PgQueue.Queue do
  use GenServer

  def child_spec(event_name, opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [event_name, opts]}
    }
  end

  def start_link(event_name, opts) do
    GenServer.start_link(__MODULE__, event_name, opts)
  end

  def alive?(event_name) do
    case Registry.lookup(PgQueue.Registry, event_name) do
      [] -> false
      [{pid, _}] -> Process.alive?(pid)
    end
  end

  def next(event_name) do
    if alive?(event_name) do
      GenServer.call(from_registry(event_name), :next)
    else
      nil
    end
  end

  @impl true
  def init(event_name) do
    with {:ok, _pid, _ref} <- StreamPgKinesis.Repo.listen(event_name) do
      {:ok, []}
    else
      error -> {:stop, error}
    end
  end

  @impl true
  def handle_call(:next, _from, []) do
    {:reply, nil, []}
  end

  @impl true
  def handle_call(:next, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_info({:notification, _pid, _ref, _event_name, payload}, queue) do
    with {:ok, %{record: record}} <- Jason.decode(payload, keys: :atoms) do
      {:noreply, queue ++ [record]}
    else
      error -> {:stop, error, queue}
    end
  end

  defp from_registry(event_name) do
    {:via, Registry, {PgQueue.Registry, event_name}}
  end
end
