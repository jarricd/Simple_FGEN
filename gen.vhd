library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
entity gen is 
	port(
			clk_in : in std_logic;
			clk_out : out std_logic;
			clock_select : in std_logic_vector (3 downto 0);
			first_digit : out std_logic_vector (6 downto 0);
			second_digit : out std_logic_vector (6 downto 0);
			third_digit : out std_logic_vector (6 downto 0);
			fourth_digit : out std_logic_vector (6 downto 0);
			external_fout : out std_logic;
			multipliers : in std_logic_vector (3 downto 0)
		);
end gen;	


architecture gen_rtl of gen is

	signal counter : natural := 0;
	signal clk_outState : std_logic := '0';
	signal clk_external_out : std_logic := '0';
	signal multiplier : natural := 1;

begin

	process (clk_in, clock_select, multipliers) is
		variable prescaler : natural := 2499999;
		
	begin
		if rising_edge(clk_in) then
			
			case multipliers is
				when "0000" => 
					multiplier <= 1;
				when "0001" => 
					multiplier <= 2;
				when "0010" => 
					multiplier <= 4;
				when "0100" =>
					multiplier <= 6;
				when "1000" =>
					multiplier <= 8;
				when others =>
					multiplier <= 1;
			end case;

			case clock_select is
				when "0000" =>
					clk_outState <= '0';
					clk_external_out <= '0';
					first_digit <= "0000001";
					second_digit <= "0000001";
					third_digit <= "0000001";
					fourth_digit <= "0000001";
				when "0001" =>
					prescaler := 2499999 / multiplier;
					first_digit <= "0000001";
					second_digit <= "1001111";
					third_digit <= "0000001";
					fourth_digit <= "0000001";
				when "0010" =>
					prescaler := 249999 / multiplier;
					first_digit <= "0000001";
					second_digit <= "0000001";
					third_digit <= "1001111";
					fourth_digit <= "0000001";
				when "0100" =>
					prescaler := 24999 / multiplier;
					first_digit <= "0000001";
					second_digit <= "0000001";
					third_digit <= "0000001";
					fourth_digit <= "1001111";
				when "1000" =>
					prescaler := 2499 / multiplier;
					first_digit <= "0000100";
					second_digit <= "0000100";
					third_digit <= "0000100";
					fourth_digit <= "0000100";
				when others =>
					clk_outState <= '0';
					clk_external_out <= '0';
			end case;
			
			if counter >= prescaler then
				counter <= 0;
				if clk_outState = '0' then
					clk_outState <= '1';
					clk_external_out <= '1';
				else
					clk_outState <= '0';
					clk_external_out <= '0';
				end if;
			else
				counter <= counter + 1;
			end if;
			
			clk_out <= clk_outState;
			external_fout <= clk_external_out;
			
		end if;

	end process;
	
end gen_rtl;