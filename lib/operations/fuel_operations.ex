defmodule NasaFuelator.Operations.FuelOperations do
  def predict_spacecraft_fuel_requirements(spacecraft_mass, instructions)
      when is_integer(spacecraft_mass) and is_list(instructions) do
    instructions = Enum.reverse(instructions)

    fuel_from_instructions(spacecraft_mass, instructions) - spacecraft_mass
  end

  defp fuel_from_instructions(result, []), do: result

  defp fuel_from_instructions(total_mass, [{action, gravity} | tail]) do
    res = calculate_fuel_for_mass_after_action(total_mass, gravity, action)

    fuel_from_instructions(res + total_mass, tail)
  end

  defp calc_fuel(mass, gravity, :launch), do: (mass * gravity * 0.042 - 33) |> floor_or_default()
  defp calc_fuel(mass, gravity, :land), do: (mass * gravity * 0.033 - 42) |> floor_or_default()

  defp calc_additional_fuel(total_fuel, mass_left, _, _) when mass_left <= 0, do: total_fuel

  defp calc_additional_fuel(total_fuel, mass_left, gravity, action) do
    mass_left = calc_fuel(mass_left, gravity, action)

    calc_additional_fuel(total_fuel + mass_left, mass_left, gravity, action)
  end

  defp calc_additional_fuel(total_fuel, gravity, action),
    do: calc_additional_fuel(total_fuel, total_fuel, gravity, action)

  defp floor_or_default(value) when value <= 0, do: 0
  defp floor_or_default(value), do: Float.floor(value)

  defp calculate_fuel_for_mass_after_action(mass, gravity, action) do
    calc_fuel(mass, gravity, action)
    |> calc_additional_fuel(gravity, action)
  end
end
