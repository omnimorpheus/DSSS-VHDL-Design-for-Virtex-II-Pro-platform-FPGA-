-----------------------------------------------------------------
-- Project    : Labo Digitale Elektronica
-- Author     : Jelle Meeus - campus De Nayer
-- Begin Date : 11/03/2015
-- RevISion   : version 1 - 18/03/2010 - Jelle Meeus
-- File       : comp_GENERIC.vhd
-----------------------------------------------------------------
-- Design: 
-- COMPARATOR
--
-- Description:
-- ThIS entity/architecture pair IS a COMPARATOR
-- with 2 binary inputs (A,B) and 2 binary outputs (LED).
-----------------------------------------------------------------
ENTITY COMPARATOR IS
    PORT (A : IN std_logic_vector( 5 DOWNTO 0);
        B : IN std_logic_vector( 5 DOWNTO 0);
        C : OUT std_logic;
        D : OUT std_logic;
         );
END COMPARATOR;

ARCHITECTURE behavior of COMPARATOR IS
   COMPONENT CMP
	GENERIC ( W : integer := 7 );
    PORT(
         A : IN std_logic_vector( W DOWNTO 0);
         B : IN std_logic_vector( W DOWNTO 0);
         C : OUT std_logic;
         D : OUT std_logic;
        );
    END COMPONENT;
SIGNAL C1,D1,C2,D2 : std_logic:='0';
BEGIN
	CMPH : CMP GENERIC MAP (W => 3) PORT MAP (
		A => A(5 DOWNTO 3),
		B => B(5 DOWNTO 3),
		C => C1,
		D => D1 );.
	CMPL : CMP GENERIC MAP (W => 3) PORT MAP (
		A => A(2 DOWNTO 0),
		B => B(2 DOWNTO 0),
		C => C2,
		D => D2 );
C <= (C2 >= C1);  
D <= (D2 = D1);
END;