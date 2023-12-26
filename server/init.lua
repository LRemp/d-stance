CreateThread(function()
    if Config.EnableMenu then
        MySQL.query('CREATE TABLE IF NOT EXISTS `vehicle_stance` (`id` int(11) NOT NULL AUTO_INCREMENT, `numberplate` varchar(50) NOT NULL, `preset` text NOT NULL, PRIMARY KEY (`id`), UNIQUE KEY `numberplate` (`numberplate`))')
    end
end)