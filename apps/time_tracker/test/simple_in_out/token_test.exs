defmodule SimpleInOut.TokenTest do
  use ExUnit.Case, async: true

  describe "fetch_token" do
    test "should work for a valid code" do
      response = SimpleInOut.fetch_token("a_valid_code")
      assert response == "a_valid_token"
    end

    test "should error for unparseable response" do
      error = catch_error(SimpleInOut.fetch_token("force_bad_response"))
      assert error.code == "simple-in-out/parse-error"
    end

    test "should forward errors" do
      error = catch_error(SimpleInOut.fetch_token("an_invalid_code"))
      assert error.code == "simple-in-out/upstream-error"
      assert error.message =~ ~r/Invalid code/
    end
  end
end
