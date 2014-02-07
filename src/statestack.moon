export ^

class StateStack
    -- General purpose class to handle multiple state in LOVE games
    new: =>
        @stack = {}

    push: (state) =>
        table.insert @stack, state

    pop: =>
        table.remove @stack

    peek: =>
        @stack[#@stack]
