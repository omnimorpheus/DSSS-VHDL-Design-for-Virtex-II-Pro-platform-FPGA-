testvector("10000"); --reset
	 wait for 5*period;
	--Up/down counter op x zetten (1010)
	for J in 1 to 8 loop   --x optellen    
		for I in 1 to 6*2 loop --1x UP indrukken
		testvector("10011");
		end loop;
		for I in 1 to 6*2 loop --1x UP loslaten
		testvector("10001");
		end loop;		 
	end loop;
	--

	--run	ml2
	for J in 1 to 32*2 loop
		for I in 1 to 32*2 loop
			testvector("10001");
		end loop;
	end loop;	
	
	testvector("11000"); --reset
	 wait for 5*period;
	--Up/down counter op x zetten (1010)
	for J in 1 to 4 loop   --x optellen    
		for I in 1 to 6*2 loop --1x UP indrukken
		testvector("11011");
		end loop;
		for I in 1 to 6*2 loop --1x UP loslaten
		testvector("11001");
		end loop;		 
	end loop;
	--
	
	--run	gold
	for J in 1 to 32*2 loop
		for I in 1 to 32*2 loop
			testvector("11001");
		end loop;
	end loop;	
	
	testvector("00000"); --reset
	 wait for 5*period;
	--Up/down counter op x zetten (1010)
	for J in 1 to 5 loop   --x optellen    
		for I in 1 to 6*2 loop --1x UP indrukken
		testvector("00011");
		end loop;
		for I in 1 to 6*2 loop --1x UP loslaten
		testvector("00001");
		end loop;		 
	end loop;
	--

	--run	ml0
	for J in 1 to 600 loop
		for I in 1 to 50 loop
			testvector("00001");
		end loop;
	end loop;	