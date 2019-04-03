defmodule SimpleInOut.Error.ConnectionError do
  defexception [:message, :code]

  @impl true
  def exception(_value) do
    %__MODULE__{
      message: "Unable to connect to Simple in/out",
      code: "simple-in-out/connection-error"
    }
  end
end
