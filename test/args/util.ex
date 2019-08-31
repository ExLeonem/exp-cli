defmodule Pow.Args.Util do
    
    def invalid_args?({argv, left, invalid} = result) do
        if Enum.empty?(left) && Enum.empty?(invalid) do
            result
        else
            {:error, :invalid_param}
        end
    end


    def extract_captured() do
        
    end

end