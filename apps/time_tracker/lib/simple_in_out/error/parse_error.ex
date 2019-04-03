defmodule SimpleInOut.Error.ParseError do
  defexception [:message, :code]

  @impl true
  def exception(_value) do
    %__MODULE__{
      message: "Error parsing JSON payload from Simple In/Out",
      code: "simple-in-out/parse-error"
    }
  end
end
