local module = {}
module.__index = module

function module.Create(
)
	
	local self = setmetatable(
		{
			
			Tasks = {}
		}, module
	)
	return self
end

function module:Task(
	instance : Instance
)
	
	table.insert(
		self.Tasks, Instance
	)
end

function module:__RBXScriptConnection(
	instance : RBXScriptConnection
)
	
	instance:Disconnect()
	instance = nil
end

function module:__Instance(
	instance : Instance
)

	instance:Destroy()
end

function module:__Run(
	instance : Instance
)
	
	local unique = string.format(
		'__%s', typeof(
			instance
		)
	)
	if not self[unique] then
		
		return
	end
	
	self[unique](
		instance
	)
end

function module:Clean(
)
	
	for _, instance in self.Tasks do
		
		self:__Run(
			instance
		)
	end
	self.Tasks = {}
end

return module
