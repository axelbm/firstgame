
if not game then game = {} end

local color = {
	r = 0,
	g = 0,
	b = 0,
	a = 255
}

local color_mt = {
	__index = color, 
	__type = "color",
	__tostring = function(color)
		return "Color [" .. color.r .. ", " .. color.g .. ", " .. color.b .. ", " .. color.a .. "]"
	end,
	__eq = function(col1, col2)
		if not iscolor(col1) or not iscolor(col2) then return false end
		return col1.r == col2.r and col1.g == col2.g and col1.b == col2.b and col1.a == col2.a
	end
}

function Color(r, g, b, a)
	local self = {}
	setmetatable(self, color_mt)
	self.r = r or 0
	self.g = g or r
	self.b = b or r
	self.a = a or 255

	assert(isnumber(self.r), "bad argument #1 to 'Color' (number expected, got ".. type(self.r).. ")")
	assert(isnumber(self.g), "bad argument #2 to 'Color' (number expected, got ".. type(self.g).. ")")
	assert(isnumber(self.b), "bad argument #3 to 'Color' (number expected, got ".. type(self.b).. ")")
	assert(isnumber(self.a), "bad argument #4 to 'Color' (number expected, got ".. type(self.a).. ")")

	return self
end

function color:alpha(a)
	return Color(self.r, self.g, self.b, a)
end

function color:rgb()
	return self.r, self.g, self.b
end

function color:rgba()
	return self.r, self.g, self.b, self.a
end

function iscolor(...)
	return istype(color_mt.__type, ...)
end

game.colors = {
	almond                  	= Color(239,222,205),
	antique_brass           	= Color(205,149,117),
	apricot                 	= Color(253,217,181),
	aquamarine              	= Color(120,219,226),
	asparagus               	= Color(135,169,107),
	atomic_tangerine        	= Color(255,164,116),
	banana_mania            	= Color(250,231,181),
	beaver                  	= Color(159,129,112),
	bittersweet             	= Color(253,124,110),
	black                   	= Color(0,0,0),
	blizzard_blue           	= Color(172,229,238),
	blue                    	= Color(31,117,254),
	blue_bell               	= Color(162,162,208),
	blue_gray               	= Color(102,153,204),
	blue_green              	= Color(13,152,186),
	blue_violet             	= Color(115,102,189),
	blush                   	= Color(222,93,131),
	brick_red               	= Color(203,65,84),
	brown                   	= Color(180,103,77),
	burnt_orange            	= Color(255,127,73),
	burnt_sienna            	= Color(234,126,93),
	cadet_blue              	= Color(176,183,198),
	canary                  	= Color(255,255,153),
	caribbean_green         	= Color(28,211,162),
	carnation_pink          	= Color(255,170,204),
	cerise                  	= Color(221,68,146),
	cerulean                	= Color(29,172,214),
	chestnut                	= Color(188,93,88),
	copper                  	= Color(221,148,117),
	cornflower              	= Color(154,206,235),
	cotton_candy            	= Color(255,188,217),
	dandelion               	= Color(253,219,109),
	denim                   	= Color(43,108,196),
	desert_sand             	= Color(239,205,184),
	eggplant                	= Color(110,81,96),
	electric_lime           	= Color(206,255,29),
	fern                    	= Color(113,188,120),
	forest_green            	= Color(109,174,129),
	fuchsia                 	= Color(195,100,197),
	fuzzy_wuzzy             	= Color(204,102,102),
	gold                    	= Color(231,198,151),
	goldenrod               	= Color(252,217,117),
	granny_smith_apple      	= Color(168,228,160),
	gray                    	= Color(149,145,140),
	green                   	= Color(28,172,120),
	green_blue              	= Color(17,100,180),
	green_yellow            	= Color(240,232,145),
	hot_magenta             	= Color(255,29,206),
	inchworm                	= Color(178,236,93),
	indigo                  	= Color(93,118,203),
	jazzberry_jam           	= Color(202,55,103),
	jungle_green            	= Color(59,176,143),
	laser_lemon             	= Color(254,254,34),
	lavender                	= Color(252,180,213),
	lemon_yellow            	= Color(255,244,79),
	macaroni_and_cheese     	= Color(255,189,136),
	magenta                 	= Color(246,100,175),
	magic_mint              	= Color(170,240,209),
	mahogany                	= Color(205,74,76),
	maize                   	= Color(237,209,156),
	manatee                 	= Color(151,154,170),
	mango_tango             	= Color(255,130,67),
	maroon                  	= Color(200,56,90),
	mauvelous               	= Color(239,152,170),
	melon                   	= Color(253,188,180),
	midnight_blue           	= Color(26,72,118),
	mountain_meadow         	= Color(48,186,143),
	mulberry                	= Color(197,75,140),
	navy_blue               	= Color(25,116,210),
	neon_carrot             	= Color(255,163,67),
	olive_green             	= Color(186,184,108),
	orange                  	= Color(255,117,56),
	orange_red              	= Color(255,43,43),
	orange_yellow           	= Color(248,213,104),
	orchid                  	= Color(230,168,215),
	outer_space             	= Color(65,74,76),
	outrageous_orange       	= Color(255,110,74),
	pacific_blue            	= Color(28,169,201),
	peach                   	= Color(255,207,171),
	periwinkle              	= Color(197,208,230),
	piggy_pink              	= Color(253,221,230),
	pine_green              	= Color(21,128,120),
	pink_flamingo           	= Color(252,116,253),
	pink_sherbet            	= Color(247,143,167),
	plum                    	= Color(142,69,133),
	purple_heart            	= Color(116,66,200),
	purple_mountains_majesty	= Color(157,129,186),
	purple_pizzazz          	= Color(254,78,218),
	radical_red             	= Color(255,73,108),
	raw_sienna              	= Color(214,138,89),
	raw_umber               	= Color(113,75,35),
	razzle_dazzle_rose      	= Color(255,72,208),
	razzmatazz              	= Color(227,37,107),
	red                     	= Color(238,32,77),
	red_orange              	= Color(255,83,73),
	red_violet              	= Color(192,68,143),
	robins_egg_blue         	= Color(31,206,203),
	royal_purple            	= Color(120,81,169),
	salmon                  	= Color(255,155,170),
	scarlet                 	= Color(252,40,71),
	screamin_green          	= Color(118,255,122),
	sea_green               	= Color(159,226,191),
	sepia                   	= Color(165,105,79),
	shadow                  	= Color(138,121,93),
	shamrock                	= Color(69,206,162),
	shocking_pink           	= Color(251,126,253),
	silver                  	= Color(205,197,194),
	sky_blue                	= Color(128,218,235),
	spring_green            	= Color(236,234,190),
	sunglow                 	= Color(255,207,72),
	sunset_orange           	= Color(253,94,83),
	tan                     	= Color(250,167,108),
	teal_blue               	= Color(24,167,181),
	thistle                 	= Color(235,199,223),
	tickle_me_pink          	= Color(252,137,172),
	timberwolf              	= Color(219,215,210),
	tropical_rain_forest    	= Color(23,128,109),
	tumbleweed              	= Color(222,170,136),
	turquoise_blue          	= Color(119,221,231),
	unmellow_yellow         	= Color(255,255,102),
	violet                  	= Color(146,110,174),
	violet_blue             	= Color(50,74,178),
	violet_red              	= Color(247,83,148),
	vivid_tangerine         	= Color(255,160,137),
	vivid_violet            	= Color(143,80,157),
	white                   	= Color(255,255,255),
	wild_blue_yonder        	= Color(162,173,208),
	wild_strawberry         	= Color(255,67,164),
	wild_watermelon         	= Color(252,108,133),
	wisteria                	= Color(205,164,222),
	yellow                  	= Color(252,232,131),
	yellow_green            	= Color(197,227,132),
	yellow_orange           	= Color(255,174,66)
}
