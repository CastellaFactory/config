local platform = require 'utils.platform'

return {
    setup = function(config)
        if platform.is_win then
            config.default_domain = 'WSL:Distrod'
        end
    end
}
