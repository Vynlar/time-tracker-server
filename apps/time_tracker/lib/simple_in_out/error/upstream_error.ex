defmodule SimpleInOut.Error.UpstreamError do
  defexception [:message, :code]

  @impl true
  def exception(error_message) do
    %__MODULE__{
      message: "Received error from Simple In/Out: #{error_message}",
      code: "simple-in-out/upstream-error"
    }
  end
end
