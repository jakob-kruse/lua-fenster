describe('fenster', function()
	local fenster = require('fenster')

	describe('fenster.open(...)', function()
		it('should throw when no arguments were given', function()
			assert.has_errors(function() fenster.open() end)
		end)

		it('should throw when not enough arguments were given', function()
			assert.has_errors(function() fenster.open(256) end)
		end)

		it('should throw when width/height are not integers', function()
			assert.has_errors(function() fenster.open('ERROR') end)
			assert.has_errors(function() fenster.open(true) end)
			assert.has_errors(function() fenster.open({}) end)
			assert.has_errors(function() fenster.open(function() end) end)
			assert.has_errors(function() fenster.open(io.stdout) end)

			assert.has_errors(function() fenster.open(256, 'ERROR') end)
			assert.has_errors(function() fenster.open(256, true) end)
			assert.has_errors(function() fenster.open(256, {}) end)
			assert.has_errors(function() fenster.open(256, function() end) end)
			assert.has_errors(function() fenster.open(256, io.stdout) end)

			if _VERSION ~= 'Lua 5.1' and _VERSION ~= 'Lua 5.2' then
				-- Lua 5.1 and 5.2 don't throw errors when using a number as an integer
				assert.has_errors(function() fenster.open(100.5) end)
				assert.has_errors(function() fenster.open(256, 100.5) end)
			end
		end)

		it('should throw when width/height are out of range', function()
			assert.has_errors(function() fenster.open(100, -100) end)
			assert.has_errors(function() fenster.open(-100, 100) end)
			assert.has_errors(function() fenster.open(30000, 100) end)
			assert.has_errors(function() fenster.open(100, 30000) end)
		end)

		it('should return a window userdata #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)
			assert.is_userdata(window)
		end)

		it('should set a default title when none is given #needsdisplay', function()
			local window = fenster.open(256, 144)
			local window2 = fenster.open(256, 144, nil)
			finally(function()
				window:close()
				window2:close()
			end)
			assert.is_string(window.title)
			assert.is_true(#window.title > 0)
			assert.is_string(window2.title)
			assert.is_true(#window2.title > 0)
		end)

		it('should throw when title is not a string', function()
			assert.has_errors(function() fenster.open(256, 144, true) end)
			assert.has_errors(function() fenster.open(256, 144, {}) end)
			assert.has_errors(function() fenster.open(256, 144, function() end) end)
			assert.has_errors(function() fenster.open(256, 144, io.stdout) end)
		end)

		it('should set the title #needsdisplay', function()
			local window = fenster.open(256, 144, 'Test')
			finally(function() window:close() end)
			assert.is_equal(window.title, 'Test')
		end)

		it('should set a default scale when none is given #needsdisplay', function()
			local window = fenster.open(256, 144)
			local window2 = fenster.open(256, 144, 'Test', nil)
			finally(function()
				window:close()
				window2:close()
			end)
			assert.is_equal(window.scale, 1)
			assert.is_equal(window2.scale, 1)
		end)

		it('should throw when scale is not an integer', function()
			assert.has_errors(function() fenster.open(256, 144, 'Test', 'ERROR') end)
			assert.has_errors(function() fenster.open(256, 144, 'Test', true) end)
			assert.has_errors(function() fenster.open(256, 144, 'Test', {}) end)
			assert.has_errors(function() fenster.open(256, 144, 'Test', function() end) end)
			assert.has_errors(function() fenster.open(256, 144, 'Test', io.stdout) end)

			if _VERSION ~= 'Lua 5.1' and _VERSION ~= 'Lua 5.2' then
				-- Lua 5.1 and 5.2 don't throw errors when using a number as an integer
				assert.has_errors(function() fenster.open(256, 144, 'Test', 2.5) end)
			end
		end)

		it('should throw when scale is not a power of 2', function()
			assert.has_errors(function() fenster.open(256, 144, 'Test', -4) end)
			assert.has_errors(function() fenster.open(256, 144, 'Test', 3) end)
		end)

		it('should set the scale #needsdisplay', function()
			local window = fenster.open(256, 144, 'Test', 4)
			finally(function() window:close() end)
			assert.is_equal(window.scale, 4)
		end)

		it('should set a default target fps when none is given #needsdisplay', function()
			local window = fenster.open(256, 144)
			local window2 = fenster.open(256, 144, 'Test', 1, nil)
			finally(function()
				window:close()
				window2:close()
			end)
			assert.is_equal(window.targetfps, 60.0)
			assert.is_equal(window2.targetfps, 60.0)
		end)

		it('should throw when target fps is not a number', function()
			assert.has_errors(function() fenster.open(256, 144, 'Test', 1, 'ERROR') end)
			assert.has_errors(function() fenster.open(256, 144, 'Test', 1, true) end)
			assert.has_errors(function() fenster.open(256, 144, 'Test', 1, {}) end)
			assert.has_errors(function() fenster.open(256, 144, 'Test', 1, function() end) end)
			assert.has_errors(function() fenster.open(256, 144, 'Test', 1, io.stdout) end)
		end)

		it('should throw when target fps is out of range', function()
			assert.has_errors(function() fenster.open(256, 144, 'Test', 1, -30) end)
		end)

		it('should set the target fps #needsdisplay', function()
			local window = fenster.open(256, 144, 'Test', 1, 30)
			finally(function() window:close() end)
			assert.is_equal(window.targetfps, 30)
		end)
	end)

	describe('fenster.sleep(...)', function()
		it('should throw when no arguments were given', function()
			assert.has_errors(function() fenster.sleep() end)
		end)

		it('should throw when milliseconds is not an integer', function()
			assert.has_errors(function() fenster.sleep('ERROR') end)
			assert.has_errors(function() fenster.sleep(true) end)
			assert.has_errors(function() fenster.sleep({}) end)
			assert.has_errors(function() fenster.sleep(function() end) end)
			assert.has_errors(function() fenster.sleep(io.stdout) end)

			if _VERSION ~= 'Lua 5.1' and _VERSION ~= 'Lua 5.2' then
				-- Lua 5.1 and 5.2 don't throw errors when using a number as an integer
				assert.has_errors(function() fenster.sleep(2.5) end)
			end
		end)

		it('should sleep for the given amount of time', function()
			local start = fenster.time()
			fenster.sleep(2)
			local stop = fenster.time()
			assert.is_true(stop - start >= 2)
		end)
	end)

	describe('fenster.time(...)', function()
		it('should return the current time in seconds', function()
			local time = fenster.time()
			assert.is_number(time)
		end)
	end)

	describe('fenster.rgb(...)', function()
		it('should throw when no arguments were given', function()
			assert.has_errors(function() fenster.rgb() end)
		end)

		it('should throw when color is not an integer', function()
			assert.has_errors(function() fenster.rgb('ERROR') end)
			assert.has_errors(function() fenster.rgb(true) end)
			assert.has_errors(function() fenster.rgb({}) end)
			assert.has_errors(function() fenster.rgb(function() end) end)
			assert.has_errors(function() fenster.rgb(io.stdout) end)

			if _VERSION ~= 'Lua 5.1' and _VERSION ~= 'Lua 5.2' then
				-- Lua 5.1 and 5.2 don't throw errors when using a number as an integer
				assert.has_errors(function() fenster.rgb(2.5) end)
			end
		end)

		it('should throw when color is out of range', function()
			assert.has_errors(function() fenster.rgb(-1) end)
			assert.has_errors(function() fenster.rgb(0x1000000) end)
		end)

		it('should convert a color to r/g/b', function()
			assert.is_same({ fenster.rgb(0x000000) }, { 0, 0, 0 })
			assert.is_same({ fenster.rgb(0x0000ff) }, { 0, 0, 255 })
			assert.is_same({ fenster.rgb(0x00ff00) }, { 0, 255, 0 })
			assert.is_same({ fenster.rgb(0x00ffff) }, { 0, 255, 255 })
			assert.is_same({ fenster.rgb(0xff0000) }, { 255, 0, 0 })
			assert.is_same({ fenster.rgb(0xff00ff) }, { 255, 0, 255 })
			assert.is_same({ fenster.rgb(0xffff00) }, { 255, 255, 0 })
			assert.is_same({ fenster.rgb(0xffffff) }, { 255, 255, 255 })
			assert.is_same({ fenster.rgb(0xbeef99) }, { 190, 239, 153 })
		end)

		it('should throw when r/g/b are not integers', function()
			assert.has_errors(function() fenster.rgb('ERROR', 0, 0) end)
			assert.has_errors(function() fenster.rgb(true, 0, 0) end)
			assert.has_errors(function() fenster.rgb({}, 0, 0) end)
			assert.has_errors(function() fenster.rgb(function() end, 0, 0) end)
			assert.has_errors(function() fenster.rgb(io.stdout) end)

			assert.has_errors(function() fenster.rgb(0, 'ERROR', 0) end)
			assert.has_errors(function() fenster.rgb(0, true, 0) end)
			assert.has_errors(function() fenster.rgb(0, {}, 0) end)
			assert.has_errors(function() fenster.rgb(0, function() end, 0) end)
			assert.has_errors(function() fenster.rgb(0, io.stdout, 0) end)

			assert.has_errors(function() fenster.rgb(0, 0, 'ERROR') end)
			assert.has_errors(function() fenster.rgb(0, 0, true) end)
			assert.has_errors(function() fenster.rgb(0, 0, {}) end)
			assert.has_errors(function() fenster.rgb(0, 0, function() end) end)
			assert.has_errors(function() fenster.rgb(0, 0, io.stdout) end)

			if _VERSION ~= 'Lua 5.1' and _VERSION ~= 'Lua 5.2' then
				-- Lua 5.1 and 5.2 don't throw errors when using a number as an integer
				assert.has_errors(function() fenster.rgb(255.5, 0, 0) end)
				assert.has_errors(function() fenster.rgb(0, 255.5, 0) end)
				assert.has_errors(function() fenster.rgb(0, 0, 255.5) end)
			end
		end)

		it('should throw when r/g/b are out of range', function()
			assert.has_errors(function() fenster.rgb(-1, 0, 0) end)
			assert.has_errors(function() fenster.rgb(256, 0, 0) end)

			assert.has_errors(function() fenster.rgb(0, -1, 0) end)
			assert.has_errors(function() fenster.rgb(0, 256, 0) end)

			assert.has_errors(function() fenster.rgb(0, 0, -1) end)
			assert.has_errors(function() fenster.rgb(0, 0, 256) end)
		end)

		it('should convert r/g/b to a color', function()
			assert.is_equal(fenster.rgb(0, 0, 0), 0x000000)
			assert.is_equal(fenster.rgb(0, 0, 255), 0x0000ff)
			assert.is_equal(fenster.rgb(0, 255, 0), 0x00ff00)
			assert.is_equal(fenster.rgb(0, 255, 255), 0x00ffff)
			assert.is_equal(fenster.rgb(255, 0, 0), 0xff0000)
			assert.is_equal(fenster.rgb(255, 0, 255), 0xff00ff)
			assert.is_equal(fenster.rgb(255, 255, 0), 0xffff00)
			assert.is_equal(fenster.rgb(255, 255, 255), 0xffffff)
			assert.is_equal(fenster.rgb(190, 239, 153), 0xbeef99)
		end)
	end)

	describe('window:close(...) / fenster.close(...)', function()
		it('should throw when no arguments were given when not using as method', function()
			assert.has_errors(function() fenster.close() end)
		end)

		it('should throw when window is not a window userdata when not using as method', function()
			assert.has_errors(function() fenster.close(25) end)
			assert.has_errors(function() fenster.close(2.5) end)
			assert.has_errors(function() fenster.close('ERROR') end)
			assert.has_errors(function() fenster.close(true) end)
			assert.has_errors(function() fenster.close({}) end)
			assert.has_errors(function() fenster.close(function() end) end)
			assert.has_errors(function() fenster.close(io.stdout) end)
		end)

		it('should throw when window is used after closing #needsdisplay', function()
			local window = fenster.open(256, 144)
			fenster.close(window)
			assert.has_errors(function() fenster.close(window) end)
			assert.has_errors(function() fenster.loop(window) end)
			assert.has_errors(function() fenster.set(window, 0, 0, 0xffffff) end)
			assert.has_errors(function() fenster.get(window, 0, 0) end)
			assert.has_errors(function() fenster.clear(window) end)

			local window2 = fenster.open(256, 144)
			window2:close()
			assert.has_errors(function() window2:close() end)
			assert.has_errors(function() window2:loop() end)
			assert.has_errors(function() window2:set(0, 0, 0xffffff) end)
			assert.has_errors(function() window2:get(0, 0) end)
			assert.has_errors(function() window2:clear() end)
		end)
	end)

	describe('window:loop(...) / fenster.loop(...)', function()
		it('should throw when no arguments were given when not using as method', function()
			assert.has_errors(function() fenster.loop() end)
		end)

		it('should throw when window is not a window userdata when not using as method', function()
			assert.has_errors(function() fenster.loop(25) end)
			assert.has_errors(function() fenster.loop(2.5) end)
			assert.has_errors(function() fenster.loop('ERROR') end)
			assert.has_errors(function() fenster.loop(true) end)
			assert.has_errors(function() fenster.loop({}) end)
			assert.has_errors(function() fenster.loop(function() end) end)
			assert.has_errors(function() fenster.loop(io.stdout) end)
		end)

		it('should update the window successfully #needsdisplay', function()
			local window = fenster.open(256, 144)
			local window2 = fenster.open(256, 144)
			finally(function()
				fenster.close(window)
				window2:close()
			end)
			assert.is_true(fenster.loop(window))
			assert.is_true(window2:loop())
		end)
	end)

	describe('window:set(...) / fenster.set(...)', function()
		it('should throw when no arguments were given when not using as method', function()
			assert.has_errors(function() fenster.set() end)
		end)

		it('should throw when window is not a window userdata when not using as method', function()
			assert.has_errors(function() fenster.set(25, 0, 0, 0) end)
			assert.has_errors(function() fenster.set(2.5, 0, 0, 0) end)
			assert.has_errors(function() fenster.set('ERROR', 0, 0, 0) end)
			assert.has_errors(function() fenster.set(true, 0, 0, 0) end)
			assert.has_errors(function() fenster.set({}, 0, 0, 0) end)
			assert.has_errors(function() fenster.set(function() end, 0, 0, 0) end)
			assert.has_errors(function() fenster.set(io.stdout, 0, 0, 0) end)
		end)

		it('should throw when x/y are not integers #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)

			assert.has_errors(function() fenster.set(window, 'ERROR', 0, 0) end)
			assert.has_errors(function() fenster.set(window, true, 0, 0) end)
			assert.has_errors(function() fenster.set(window, {}, 0, 0) end)
			assert.has_errors(function() fenster.set(window, function() end, 0, 0) end)
			assert.has_errors(function() fenster.set(window, io.stdout, 0, 0) end)
			assert.has_errors(function() fenster.set(window, 0, 'ERROR', 0) end)
			assert.has_errors(function() fenster.set(window, 0, true, 0) end)
			assert.has_errors(function() fenster.set(window, 0, {}, 0) end)
			assert.has_errors(function() fenster.set(window, 0, function() end, 0) end)
			assert.has_errors(function() fenster.set(window, 0, io.stdout, 0) end)

			assert.has_errors(function() window:set('ERROR', 0, 0) end)
			assert.has_errors(function() window:set(true, 0, 0) end)
			assert.has_errors(function() window:set({}, 0, 0) end)
			assert.has_errors(function() window:set(function() end, 0, 0) end)
			assert.has_errors(function() window:set(io.stdout, 0, 0) end)
			assert.has_errors(function() window:set(0, 'ERROR', 0) end)
			assert.has_errors(function() window:set(0, true, 0) end)
			assert.has_errors(function() window:set(0, {}, 0) end)
			assert.has_errors(function() window:set(0, function() end, 0) end)
			assert.has_errors(function() window:set(0, io.stdout, 0) end)

			if _VERSION ~= 'Lua 5.1' and _VERSION ~= 'Lua 5.2' then
				-- Lua 5.1 and 5.2 don't throw errors when using a number as an integer
				assert.has_errors(function() fenster.set(window, 2.5, 0, 0) end)
				assert.has_errors(function() fenster.set(window, 0, 2.5, 0) end)
				assert.has_errors(function() window:set(2.5, 0, 0) end)
				assert.has_errors(function() window:set(0, 2.5, 0) end)
			end
		end)

		it('should throw when color is not an integer #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)

			assert.has_errors(function() fenster.set(window, 0, 0, 'ERROR') end)
			assert.has_errors(function() fenster.set(window, 0, 0, true) end)
			assert.has_errors(function() fenster.set(window, 0, 0, {}) end)
			assert.has_errors(function() fenster.set(window, 0, 0, function() end) end)
			assert.has_errors(function() fenster.set(window, 0, 0, io.stdout) end)

			assert.has_errors(function() window:set(0, 0, 'ERROR') end)
			assert.has_errors(function() window:set(0, 0, true) end)
			assert.has_errors(function() window:set(0, 0, {}) end)
			assert.has_errors(function() window:set(0, 0, function() end) end)
			assert.has_errors(function() window:set(0, 0, io.stdout) end)

			if _VERSION ~= 'Lua 5.1' and _VERSION ~= 'Lua 5.2' then
				-- Lua 5.1 and 5.2 don't throw errors when using a number as an integer
				assert.has_errors(function() fenster.set(window, 0, 0, 2.5) end)
				assert.has_errors(function() window:set(0, 0, 2.5) end)
			end
		end)

		it('should throw when x/y are out of range #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)

			assert.has_errors(function() fenster.set(window, -1, 0, 0) end)
			assert.has_errors(function() fenster.set(window, 256, 0, 0) end)
			assert.has_errors(function() fenster.set(window, 0, -1, 0) end)
			assert.has_errors(function() fenster.set(window, 0, 144, 0) end)

			assert.has_errors(function() window:set(-1, 0, 0) end)
			assert.has_errors(function() window:set(256, 0, 0) end)
			assert.has_errors(function() window:set(0, -1, 0) end)
			assert.has_errors(function() window:set(0, 144, 0) end)
		end)

		it('should throw when color is out of range #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)

			assert.has_errors(function() fenster.set(window, 0, 0, -1) end)
			assert.has_errors(function() fenster.set(window, 0, 0, 0x1000000) end)

			assert.has_errors(function() window:set(0, 0, -1) end)
			assert.has_errors(function() window:set(0, 0, 0x1000000) end)
		end)

		it('should set a pixel successfully #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)

			fenster.set(window, 20, 20, 0xbeef99)
			assert.is_equal(fenster.get(window, 20, 20), 0xbeef99)

			window:set(20, 20, 0xbeef99)
			assert.is_equal(window:get(20, 20), 0xbeef99)
		end)
	end)

	describe('window:get(...) / fenster.get(...)', function()
		it('should throw when no arguments were given when not using as method', function()
			assert.has_errors(function() fenster.get() end)
		end)

		it('should throw when window is not a window userdata when not using as method', function()
			assert.has_errors(function() fenster.get(25, 0, 0) end)
			assert.has_errors(function() fenster.get(2.5, 0, 0) end)
			assert.has_errors(function() fenster.get('ERROR', 0, 0) end)
			assert.has_errors(function() fenster.get(true, 0, 0) end)
			assert.has_errors(function() fenster.get({}, 0, 0) end)
			assert.has_errors(function() fenster.get(function() end, 0, 0) end)
			assert.has_errors(function() fenster.get(io.stdout, 0, 0) end)
		end)

		it('should throw when x/y are not integers #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)

			assert.has_errors(function() fenster.get(window, 'ERROR', 0) end)
			assert.has_errors(function() fenster.get(window, true, 0) end)
			assert.has_errors(function() fenster.get(window, {}, 0) end)
			assert.has_errors(function() fenster.get(window, function() end, 0) end)
			assert.has_errors(function() fenster.get(window, io.stdout, 0) end)
			assert.has_errors(function() fenster.get(window, 0, 'ERROR') end)
			assert.has_errors(function() fenster.get(window, 0, true) end)
			assert.has_errors(function() fenster.get(window, 0, {}) end)
			assert.has_errors(function() fenster.get(window, 0, function() end) end)
			assert.has_errors(function() fenster.get(window, 0, io.stdout) end)

			assert.has_errors(function() window:get('ERROR', 0) end)
			assert.has_errors(function() window:get(true, 0) end)
			assert.has_errors(function() window:get({}, 0) end)
			assert.has_errors(function() window:get(function() end, 0) end)
			assert.has_errors(function() window:get(io.stdout, 0) end)
			assert.has_errors(function() window:get(0, 'ERROR') end)
			assert.has_errors(function() window:get(0, true) end)
			assert.has_errors(function() window:get(0, {}) end)
			assert.has_errors(function() window:get(0, function() end) end)
			assert.has_errors(function() window:get(0, io.stdout) end)

			if _VERSION ~= 'Lua 5.1' and _VERSION ~= 'Lua 5.2' then
				-- Lua 5.1 and 5.2 don't throw errors when using a number as an integer
				assert.has_errors(function() fenster.get(window, 2.5, 0) end)
				assert.has_errors(function() fenster.get(window, 0, 2.5) end)
				assert.has_errors(function() window:get(2.5, 0) end)
				assert.has_errors(function() window:get(0, 2.5) end)
			end
		end)

		it('should throw when x/y are out of range #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)

			assert.has_errors(function() fenster.get(window, -1, 0) end)
			assert.has_errors(function() fenster.get(window, 256, 0) end)
			assert.has_errors(function() fenster.get(window, 0, -1) end)
			assert.has_errors(function() fenster.get(window, 0, 144) end)

			assert.has_errors(function() window:get(-1, 0) end)
			assert.has_errors(function() window:get(256, 0) end)
			assert.has_errors(function() window:get(0, -1) end)
			assert.has_errors(function() window:get(0, 144) end)
		end)

		it('should return the color of a pixel successfully #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)

			fenster.set(window, 0, 0, 0xf00f00)
			assert.is_equal(fenster.get(window, 0, 0), 0xf00f00)

			window:set(0, 0, 0xf00f00)
			assert.is_equal(window:get(0, 0), 0xf00f00)
		end)
	end)

	describe('window:clear(...) / fenster.clear(...)', function()
		it('should throw when no arguments were given when not using as method', function()
			assert.has_errors(function() fenster.clear() end)
		end)

		it('should throw when window is not a window userdata when not using as method', function()
			assert.has_errors(function() fenster.clear(25) end)
			assert.has_errors(function() fenster.clear(2.5) end)
			assert.has_errors(function() fenster.clear('ERROR') end)
			assert.has_errors(function() fenster.clear(true) end)
			assert.has_errors(function() fenster.clear({}) end)
			assert.has_errors(function() fenster.clear(function() end) end)
			assert.has_errors(function() fenster.clear(io.stdout) end)
		end)

		it('should clear the window successfully #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)

			fenster.set(window, 0, 0, 0xf00f00)
			fenster.set(window, 255, 143, 0xbeef99)
			fenster.clear(window)
			assert.is_equal(fenster.get(window, 0, 0), 0x000000)
			assert.is_equal(fenster.get(window, 255, 143), 0x000000)

			window:set(0, 0, 0xf00f00)
			window:set(255, 143, 0xbeef99)
			window:clear()
			assert.is_equal(window:get(0, 0), 0x000000)
			assert.is_equal(window:get(255, 143), 0x000000)
		end)

		it('should throw when color is not an integer #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)

			assert.has_errors(function() fenster.clear(window, 'ERROR') end)
			assert.has_errors(function() fenster.clear(window, true) end)
			assert.has_errors(function() fenster.clear(window, {}) end)
			assert.has_errors(function() fenster.clear(window, function() end) end)
			assert.has_errors(function() fenster.clear(window, io.stdout) end)

			assert.has_errors(function() window:clear('ERROR') end)
			assert.has_errors(function() window:clear(true) end)
			assert.has_errors(function() window:clear({}) end)
			assert.has_errors(function() window:clear(function() end) end)
			assert.has_errors(function() window:clear(io.stdout) end)

			if _VERSION ~= 'Lua 5.1' and _VERSION ~= 'Lua 5.2' then
				-- Lua 5.1 and 5.2 don't throw errors when using a number as an integer
				assert.has_errors(function() fenster.clear(window, 2.5) end)
				assert.has_errors(function() window:clear(2.5) end)
			end
		end)

		it('should throw when color is out of range #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)

			assert.has_errors(function() fenster.clear(window, -1) end)
			assert.has_errors(function() fenster.clear(window, 0x1000000) end)

			assert.has_errors(function() window:clear(-1) end)
			assert.has_errors(function() window:clear(0x1000000) end)
		end)

		it('should clear the window with a color successfully #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)

			fenster.set(window, 0, 0, 0xf00f00)
			fenster.set(window, 255, 143, 0xbeef99)
			fenster.clear(window, 0x00ff00)
			assert.is_equal(fenster.get(window, 0, 0), 0x00ff00)
			assert.is_equal(fenster.get(window, 255, 143), 0x00ff00)

			window:set(0, 0, 0xf00f00)
			window:set(255, 143, 0xbeef99)
			window:clear(0xff0000)
			assert.is_equal(window:get(0, 0), 0xff0000)
			assert.is_equal(window:get(255, 143), 0xff0000)
		end)
	end)

	describe('window.keys', function()
		it('should be a table of 256 booleans #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)
			assert.is_table(window.keys)

			local index = 0
			while window.keys[index] ~= nil do
				assert.is_boolean(window.keys[index])
				index = index + 1
			end
			assert.is_equal(index, 256)
		end)
	end)

	describe('window.delta', function()
		it('should be a number and be zero before the second frame #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)
			assert.is_number(window.delta)
			assert.is_equal(window.delta, 0)
			window:loop()
			assert.is_equal(window.delta, 0)
		end)
	end)

	describe('window.mousex', function()
		it('should be a integer and be zero before the first frame #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)
			assert.is_number(window.mousex)
			assert.is_equal(window.mousex, 0)
		end)
	end)

	describe('window.mousey', function()
		it('should be a integer and be zero before the first frame #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)
			assert.is_number(window.mousey)
			assert.is_equal(window.mousey, 0)
		end)
	end)

	describe('window.mousedown', function()
		it('should be a boolean and be false before the first frame #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)
			assert.is_boolean(window.mousedown)
			assert.is_false(window.mousedown)
		end)
	end)

	describe('window.modcontrol', function()
		it('should be a boolean and be false before the first frame #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)
			assert.is_boolean(window.modcontrol)
			assert.is_false(window.modcontrol)
		end)
	end)

	describe('window.modshift', function()
		it('should be a boolean and be false before the first frame #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)
			assert.is_boolean(window.modshift)
			assert.is_false(window.modshift)
		end)
	end)

	describe('window.modalt', function()
		it('should be a boolean and be false before the first frame #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)
			assert.is_boolean(window.modalt)
			assert.is_false(window.modalt)
		end)
	end)

	describe('window.modgui', function()
		it('should be a boolean and be false before the first frame #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)
			assert.is_boolean(window.modgui)
			assert.is_false(window.modgui)
		end)
	end)

	describe('window.width', function()
		it('should be an integer and be the same as passed to open #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)
			assert.is_number(window.width)
			assert.is_equal(window.width, 256)
		end)
	end)

	describe('window.height', function()
		it('should be an integer and be the same as passed to open #needsdisplay', function()
			local window = fenster.open(256, 144)
			finally(function() window:close() end)
			assert.is_number(window.height)
			assert.is_equal(window.height, 144)
		end)
	end)

	describe('window.title', function()
		it('should be a string and be the same as passed to open #needsdisplay', function()
			local window = fenster.open(256, 144, 'Test')
			finally(function() window:close() end)
			assert.is_string(window.title)
			assert.is_equal(window.title, 'Test')
		end)
	end)

	describe('window.scale', function()
		it('should be an integer and be the same as passed to open #needsdisplay', function()
			local window = fenster.open(256, 144, 'Test', 4)
			finally(function() window:close() end)
			assert.is_number(window.scale)
			assert.is_equal(window.scale, 4)
		end)
	end)

	describe('window.targetfps', function()
		it('should be an integer and be the same as passed to open #needsdisplay', function()
			local window = fenster.open(256, 144, 'Test', 1, 30)
			finally(function() window:close() end)
			assert.is_number(window.targetfps)
			assert.is_equal(window.targetfps, 30)
		end)
	end)
end)
