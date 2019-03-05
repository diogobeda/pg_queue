defmodule StreamPgKinesis.TestConsumer do
  use PgQueue.Consumer, event_name: "test_event"
  require Logger

  @impl true
  def handle_event(record) do
    record
      |> inspect
      |> Logger.info
  end
end
