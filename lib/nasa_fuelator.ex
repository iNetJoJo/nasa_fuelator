defmodule NasaFuelator do
  alias NasaFuelator.Operations.FuelOperations

  def calculate_fuel(mass, instructions) do
    case validate_instructions(instructions) do
      :ok -> {:ok, FuelOperations.predict_spacecraft_fuel_requirements(mass, instructions)}
      :error -> {:error, :invalid_instructions}
    end
  end

  defp validate_instructions([]), do: :ok

  defp validate_instructions([{action, gravity} | tail])
       when is_atom(action) and is_float(gravity),
       do: validate_instructions(tail)

  defp validate_instructions(_), do: :error
end
