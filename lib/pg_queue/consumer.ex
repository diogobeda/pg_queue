defmodule PgQueue.Consumer do

  @doc "Callback for processing each event that is enqueued"
  @callback handle_event(term()) :: any()

  defmacro __using__(event_name: event_name) do
    quote do
      @behaviour PgQueue.Consumer
      use GenServer

      def start_link(_opts) do
        GenServer.start_link(__MODULE__, unquote(event_name))
      end

      @impl true
      def init(event_name) do
        start_polling()
        {:ok, %{event_name: event_name}}
      end

      @impl true
      def handle_info(:poll, state = %{event_name: event_name}) do
        case PgQueue.Queue.next(event_name) do
          nil ->
            start_polling()
          record ->
            Task.async(__MODULE__, :handle_event, [record])
            |> Task.yield(:infinity)
            start_polling()
        end

        {:noreply, state}
      end

      defp start_polling() do
        send(self(), :poll)
      end
    end
  end
end
