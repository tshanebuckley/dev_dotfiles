return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Dap uses this as the namespace for its signs, we we will re-use it here
		-- From: https://github.com/mfussenegger/nvim-dap/blob/master/lua/dap/breakpoints.lua
		local ns = "dap_breakpoints"

		-- Make breakpoints tables as globals so they persists across config reloads
		_G.inactive_breakpoints = _G.inactive_breakpoints or {}
		local inactive_breakpoints = _G.inactive_breakpoints
		_G.breakpoint_data = _G.breakpoint_data or {}
		local breakpoint_data = _G.breakpoint_data

		require("dapui").setup()
		require("nvim-dap-virtual-text").setup()

		-- wire up dap ui
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- Define signs for all breakpoint states
		vim.fn.sign_define(
			"DapBreakpoint",
			{ text = "󰧞 ", texthl = "DapBreakpoint", linehl = "", numhl = "", priority = 20 }
		)
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = " ", texthl = "DapBreakpoint", linehl = "", numhl = "", priority = 20 }
		)
		vim.fn.sign_define(
			"DapLogPoint",
			{ text = " ", texthl = "DapLogPoint", linehl = "", numhl = "", priority = 20 }
		)
		vim.fn.sign_define(
			"DapStopped",
			{ text = "󱦰 ", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped", priority = 30 }
		)
		vim.fn.sign_define(
			"DapBreakpointRejected",
			{ text = " ", texthl = "DapBreakpointRejected", linehl = "", numhl = "", priority = 20 }
		)

		-- Custom signs for disabled breakpoints
		vim.fn.sign_define(
			"DapBreakpointDisabled",
			{ text = "󰄰 ", texthl = "DapBreakpoint", linehl = "", numhl = "", priority = 20 }
		)
		vim.fn.sign_define(
			"DapBreakpointConditionDisabled",
			{ text = "󰐙 ", texthl = "DapBreakpoint", linehl = "", numhl = "", priority = 20 }
		)
		vim.fn.sign_define(
			"DapLogPointDisabled",
			{ text = " ", texthl = "DapLogPoint", linehl = "", numhl = "", priority = 20 }
		)

		-- Define highlight groups with colors
		vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#FF0000" }) -- Red
		vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#00FFFF" }) -- Cyan
		vim.api.nvim_set_hl(0, "DapStopped", { fg = "#00FF00" }) -- Green
		vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#FF00FF" }) -- Magenta

		-- Remove all signs at a line
		local function remove_inactive_breakpoint(bufnr, id)
			-- Remove the sign from the gutter
			vim.fn.sign_unplace(ns, { buffer = bufnr, id = id })
			-- Remove from our tracking
			inactive_breakpoints[id] = nil
		end

		-- Convienence function to get an id from the dap sign at a line
		local function get_dap_sign_data_from_line()
			local bufnr = vim.api.nvim_get_current_buf()
			local line = vim.api.nvim_win_get_cursor(0)[1]
			local signs = vim.fn.sign_getplaced(bufnr, { group = ns, lnum = line })[1]["signs"]
			if #signs == 0 then
				return nil
			end
			return signs[1]
		end

		-- Custom function to remove a breakpoint
		local function remove_breakpoint()
			local sign = get_dap_sign_data_from_line()
			local bufnr = vim.api.nvim_get_current_buf()
			-- If we don't have a breakpoint on this line, do nothing
			if sign == nil then
				return
			end
			-- Otherwise, remove the breakpoint
			if inactive_breakpoints[sign.id] then
				-- Remove the sign
				remove_inactive_breakpoint(bufnr, sign.id)
			else
				-- Remove the breakpoint from DAP
				dap.toggle_breakpoint()
			end
		end

		-- Custom function to set breakpoint
		local function set_breakpoint()
			-- If we already have any type of breakpoint on this line, remove it
			remove_breakpoint()
			-- Set the breakpoint in DAP
			dap.set_breakpoint()
		end

		-- Set or update a conditional breakpoint
		local function set_conditional_breakpoint()
			local sign = get_dap_sign_data_from_line()
			-- Get existing condition (if any)
			local existing_condition = ""
			if sign ~= nil and breakpoint_data[sign.id] and breakpoint_data[sign.id].condition then
				existing_condition = breakpoint_data[sign.id].condition
			end

			-- Prompt with existing condition pre-filled
			local condition_prefix = "Breakpoint condition: "
			local condition = existing_condition
			vim.ui.input({ prompt = condition_prefix, default = existing_condition }, function(input)
				condition = input
			end)

      -- If the entry is canceled by the user
			if condition == nil then
				print("Conditional breakpoint canceled")
				return
			end

			-- Input should at least not be empty
			if condition == "" then
				print("Condition cannot be empty")
				return
			end

			-- Input must be have changed for action to be taken
			if condition == existing_condition then
				print("No condition was given or updated")
				return
			end

			-- Potentially remove a current breakpoint
			if sign ~= nil then
				remove_breakpoint()
			end

			-- Set the conditional breakpoint
			dap.set_breakpoint(condition)
			sign = get_dap_sign_data_from_line()
			if sign ~= nil then
				-- Track the new breakpoint
				breakpoint_data[sign.id] = {
					type = "DapBreakpointCondition",
					condition = condition,
					log_message = nil,
				}
			else
				print("An error occurred, breakpoint not set")
			end
		end

		-- Set or update a log point
		local function set_log_point()
			local sign = get_dap_sign_data_from_line()
			-- Get existing log message (if any)
			local existing_message = ""
			if sign ~= nil and breakpoint_data[sign.id] and breakpoint_data[sign.id].log_message then
				existing_message = breakpoint_data[sign.id].log_message
			end

			-- Prompt with existing message pre-filled
			local message_prefix = "Log message: "
			local log_message = existing_message
			vim.ui.input({ prompt = message_prefix, default = existing_message }, function(input)
				log_message = input
			end)

			-- If the entry is canceled by the user
			if log_message == nil then
				print("Log breakpoint canceled")
				return
			end

			-- Input should at least not be empty
			if log_message == "" then
				print("Log message cannot be empty")
				return
			end

			-- Input must have changed for action to be taken
			if log_message == existing_message then
				print("No log message given or updated")
				return
			end

			-- Potentially remove a current breakpoint
			if sign ~= nil then
				remove_breakpoint()
			end

			-- Set the log point
			dap.set_breakpoint(nil, nil, log_message)
			sign = get_dap_sign_data_from_line()
			if sign ~= nil then
				-- Track the new log point
				breakpoint_data[sign.id] = {
					type = "DapLogPoint",
					condition = nil,
					log_message = log_message,
				}
			else
				print("An error occurred, breakpoint not set")
			end
		end

		-- Toggle breakpoint enabled/disabled state
		local function toggle_breakpoint_enabled_state()
			local bufnr = vim.api.nvim_get_current_buf()
			local line = vim.api.nvim_win_get_cursor(0)[1]
			local sign = get_dap_sign_data_from_line()

			-- If we don't have a breakpoint on this line, do nothing
			if sign == nil then
				print("No breakpoint to toggle on this line")
				return
			-- Otherwise, toggle the active status
			else
				-- Choose sign based on type and enabled state
				local sign_name
        -- Going from active to inactive
				if not inactive_breakpoints[sign.id] then
					if sign.name == "DapBreakpoint" then
						sign_name = "DapBreakpointDisabled"
					elseif sign.name == "DapBreakpointCondition" then
						sign_name = "DapBreakpointConditionDisabled"
					elseif sign.name == "DapLogPoint" then
						sign_name = "DapLogPointDisabled"
					end

					-- Remove from DAP but keep sign
					local sign_id = sign.id
					dap.toggle_breakpoint()
					-- Need to add the breakpaoint to the list of inactvies
					vim.fn.sign_place(sign_id, ns, sign_name, bufnr, { lnum = line })
					inactive_breakpoints[sign_id] = get_dap_sign_data_from_line()
        -- Going from inactive to active
				else
					sign_name = sign.name
					-- Remove the disabled sign
					local sign_id = sign.id
          local sign_data = breakpoint_data[sign_id]
					remove_inactive_breakpoint(bufnr, sign.id)
					-- Re-add to DAP based on type
					-- TODO: fix the below to just return the condition and the log state. ignore the second input though.
					-- The issue is that we also need to use the old id to get the data, and then clear that bit from the state store object.
					local reset_data = true
					if sign_name == "DapBreakpointDisabled" then
						dap.set_breakpoint()
						reset_data = false
					elseif sign_name == "DapBreakpointConditionDisabled" then
						dap.set_breakpoint(breakpoint_data[sign_id].condition)
					elseif sign_name == "DapLogPointDisabled" then
						dap.set_breakpoint(nil, nil, breakpoint_data[sign_id].log_message)
					end
					-- If breakpoint data needs updated
					-- NOTE: we do not need to do this when disabling as we re-use the id
					-- however, we can not re-use the id when enabling without touching dap internals
					if reset_data then
						local new_sign = get_dap_sign_data_from_line()
						if new_sign ~= nil then
							breakpoint_data[new_sign.id] = sign_data
							return
						end
						breakpoint_data[sign_id] = nil
					end
				end
			end
		end

		-- Set up keymappings
		vim.api.nvim_set_keymap(
			"n",
			"<leader>dbr",
			":lua require('dapui').open({ reset = true})<CR>",
			{ noremap = true }
		)
		vim.keymap.set("n", "<leader>bs", set_breakpoint, { desc = "DAP: Set breakpoint" })
		vim.keymap.set("n", "<leader>br", remove_breakpoint, { desc = "DAP: Remove breakpoint" })
		vim.keymap.set("n", "<leader>bc", set_conditional_breakpoint, { desc = "DAP: Set conditional breakpoint" })
		vim.keymap.set("n", "<leader>bl", set_log_point, { desc = "DAP: Set log point" })
		vim.keymap.set("n", "<leader>bx", dap.clear_breakpoints, { desc = "DAP: Clear all breakpoints" })
		-- Add regular DAP keymappings
		vim.keymap.set("n", "<leader>dc", function()
			dap.continue()
		end, { desc = "DAP: Continue" })
		vim.keymap.set("n", "<leader>dj", function()
			dap.step_over()
		end, { desc = "DAP: Step over" })
		vim.keymap.set("n", "<leader>di", function()
			dap.step_into()
		end, { desc = "DAP: Step into" })
		vim.keymap.set("n", "<leader>do", function()
			dap.step_out()
		end, { desc = "DAP: Step out" })
		vim.keymap.set("n", "<leader>dx", function()
			dap.terminate()
		end, { desc = "DAP: Terminate" })

		-- Toggle enabled/disabled state
		vim.keymap.set("n", "<leader>bt", function()
			toggle_breakpoint_enabled_state()
		end, { desc = "DAP: Toggle breakpoint enabled/disabled" })
	end,
}
