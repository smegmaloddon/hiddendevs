local module = {}

local DEBUG = false

local MAXIMUM_ATTEMPTS = 3
local INTERVAL = 0.5

module.Services = {}

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local ServerStorage = game:GetService('ServerStorage')

local services
local modules = ReplicatedStorage:WaitForChild(
	'modules'
)

local Utilities = require(
	modules:WaitForChild(
		'Utilities'
	)
)

function module:Load(
)
	
	if RunService:IsClient() then
		
		services = script:WaitForChild(
			'clients'
		)
	elseif RunService:IsServer() then
		
		services = ServerStorage.services
	end
	
	for _, instance in services:GetChildren() do
	
		task.spawn(function(
		)
			
			local context
			local service = instance.Name
			local success, error = pcall(function(
			)

				local object = require(
					instance
				)
				module.Services[service] = object
				
				if object.Load then
					
					object:Load()
				elseif object.Create then
					
					object = object.Create()
					object:Run()
				end
			end)

			if success then

				self:__Success(
					service
				)
			elseif error then
				
				self:__Failed(
					service
				)
				warn(
					error
				)
			end
		end)
	end
end

function module:__Failed(
	service : string
)
	
	if not DEBUG then
		
		return
	end
	
	local text = string.format(
		'🟥 [%s] 🟥', Utilities.String:Upper(
			service
		)
	)
	print(
		text
	)
end

function module:__Success(
	service : string
)
	
	if not DEBUG then
		
		return
	end
	
	local total = 8
	local length = math.floor(
		#service /2
	)	
	local text = string.format(
		'🟩%s %s[%s] %s🟩', 
		Utilities.String:Repeat(
			' ', total -#service
		),
		Utilities.String:Repeat(
			' ', length
		),
		Utilities.String:Upper(
			service
		),
		Utilities.String:Repeat(
			' ', total -#service +(length)
		)
	)
	print(
		text
	)
end

function module:__Error(
	service : string
)
	
	local text = string.format(
		'🟨 [%s] 🟨', Utilities.String:Upper(
			service
		)
	)
	print(
		text
	)
end

function module:__Context(
	service : string
)

	local text = string.format(
		'⬜ [%s] ⬜', Utilities.String:Upper(
			service
		)
	)
	print(
		text
	)
end

function module:Service(
	service : string
)
	
	local object
	for i=1, MAXIMUM_ATTEMPTS do
		
		object = module.Services[service] or nil
		task.wait(
			INTERVAL
		)
	end
	
	if not object then
		
		self:__Error(
			service
		)
	end
	
	return object
end

function module:Universal(
)
	
	return module.Services
end

return module
