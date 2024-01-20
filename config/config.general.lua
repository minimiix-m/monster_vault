Config = {}

Config.EventRoute = {
    ['getSharedObject'] = 'esx:getSharedObject',                            -- Default: 'esx:getSharedObject'
    ['openVaultInventory'] = 'monster_inventoryhud:openVaultInventory',         -- ของกระเป๋า NC (ถ้าไม่ตรง ให้อ่านคำอธิบายด้านล่าง)
    --['openVaultInventory'] = 'monster_inventoryhud:openVaultInventory',   -- ของกระเป๋า esx_inventoryhud (ถ้าไม่ตรง ให้อ่านคำอธิบายด้านล่าง)
}

---อธิบาย ['openVaultInventory'] เพิ่มเติม
-- openVaultInventory คือ ชื่อ event ไว้สำหรับเปิดหน้าต่างตู้เซฟของแต่ละกระเป๋า
--      ถ้ากระเป๋า NC ให้ดูที่ nc_inventory_bridge/config.lua
--      ถ้ากระเป๋า esx_inventoryhud ให้ดูที่ esx_inventoryhud/client/vault.lua
------------------------------------------------------------------

Config.Debug = true
Config.TimeVault = 10       -- เวลาเปิดตู้เซฟ (นาที)
Config.CostOpen = 500      -- จำนวนเงินที่ใช้เปิด

Config.VaultMessage = {
    ["PutItem"] 	= "ได้ทำการนำไอเทม %s เก็บเข้าตู้เซฟ %s เป็นจำนวน %s ชิ้น",       -- นำไอเท็มเข้า
    ["PutMoney"] 	= "ได้ทำการนำเงิน %s เก็บเข้าตู้เซฟ %s เป็นจำนวน %s ดอลล่า",      -- นำเงินเข้า
    ["PutWeapon"] 	= "ได้ทำการนำอาวุธ %s เก็บเข้าตู้เซฟ %s เป็นจำนวน %s ชิ้น",        -- นำอาวุธเข้า
    ["GetItem"] 	= "ได้ทำการนำไอเทม %s ออกจากตู้เซฟ %s เป็นจำนวน %s ชิ้น",      -- นำไอเท็มออก
    ["GetMoney"] 	= "ได้ทำการนำเงิน %s ออกจากตู้เซฟ %s เป็นจำนวน %s ดอลล่า",     -- นำเงินออก
    ["GetWeapon"] 	= "ได้ทำการนำอาวุธ %s ออกจากตู้เซฟ %s เป็นจำนวน %s ชิ้น",       -- นำอาวุธออก
}

Config.VaultInventory = {
    ['vault'] = {
        Name = 'ประชาชน',
        Coords = {
            vector4(1125.3800048828125, 3062.719970703125, 45.38000106811523, 0.0)
        },
        Model = '',
        AllowBlackMoney = true,         
        NeedItemLicense = {"key_safe"},
        ItemBlackList = {},
        DiscordHook = {
            ["PutItem"]     = "link discord หรือ hook name", -- นำไอเท็มเข้า
            ["PutMoney"]    = "link discord หรือ hook name", -- นำเงินเข้า
            ["PutWeapon"]   = "link discord หรือ hook name", -- นำอาวุธเข้า
            ["GetItem"]     = "link discord หรือ hook name", -- นำไอเท็มออก
            ["GetMoney"]    = "link discord หรือ hook name", -- นำเงินออก
            ["GetWeapon"]   = "link discord หรือ hook name", -- นำอาวุธออก
        }
    },
    ['council'] = {
        Name = 'สภา',
        Coords = {
            vector4(427.41, 5.98, 91.94, 280.08),
        },
        Model = '',
        AllowBlackMoney = false,
        NeedItemLicense = {},
        ItemBlackList = {},
        DiscordHook = {
            ["PutItem"]     = "link discord หรือ hook name", -- นำไอเท็มเข้า
            ["PutMoney"]    = "link discord หรือ hook name", -- นำเงินเข้า
            ["PutWeapon"]   = "link discord หรือ hook name", -- นำอาวุธเข้า
            ["GetItem"]     = "link discord หรือ hook name", -- นำไอเท็มออก
            ["GetMoney"]    = "link discord หรือ hook name", -- นำเงินออก
            ["GetWeapon"]   = "link discord หรือ hook name", -- นำอาวุธออก
        }
    },
    -- ['police'] = {
    --     Name = 'ตำรวจ',
    --     Coords = {
    --         vector4(1759.0, 3284.56, 41.16, 280.08),
    --     },
    --     Model = '',
    --     AllowBlackMoney = false,
    --     NeedItemLicense = { 'vault_key_police' },
    --     ItemBlackList = {},
    --     DiscordHook = {
    --         ["PutItem"]     = "link discord หรือ hook name", -- นำไอเท็มเข้า
    --         ["PutMoney"]    = "link discord หรือ hook name", -- นำเงินเข้า
    --         ["PutWeapon"]   = "link discord หรือ hook name", -- นำอาวุธเข้า
    --         ["GetItem"]     = "link discord หรือ hook name", -- นำไอเท็มออก
    --         ["GetMoney"]    = "link discord หรือ hook name", -- นำเงินออก
    --         ["GetWeapon"]   = "link discord หรือ hook name", -- นำอาวุธออก
    --     }
    -- },
    -- ['ambulance'] = {
    --     Name = 'หมอ',
    --     Coords = {
    --         vector4(360.9330, -1426.44, 32.011, 238.91)
    --     },
    --     Model = '',
    --     AllowBlackMoney = false,
    --     NeedItemLicense = { 'cardvault' },
    --     ItemBlackList = {},
    --     DiscordHook = {
    --         ["PutItem"]     = "link discord หรือ hook name", -- นำไอเท็มเข้า
    --         ["PutMoney"]    = "link discord หรือ hook name", -- นำเงินเข้า
    --         ["PutWeapon"]   = "link discord หรือ hook name", -- นำอาวุธเข้า
    --         ["GetItem"]     = "link discord หรือ hook name", -- นำไอเท็มออก
    --         ["GetMoney"]    = "link discord หรือ hook name", -- นำเงินออก
    --         ["GetWeapon"]   = "link discord หรือ hook name", -- นำอาวุธออก
    --     }
    -- },
}

-- ชื่อ item ห้ามยัดเข้าตู้
Config.ItemBlackList = {
    'car_keys',
    'cardvault',
    'fashion_bunny',
    'card_x2',
    'card_x2_3d',
    'reskin_newbie',
    'fashion_acc_discordstar_h_hks_evo',
    'card_x2',
}

--TODO -- ตัวอย่างการใช้งานกับ nc_discordlogs หรือ azael_dc-serverlogs ตรง DiscordHook ให้เปลี่ยนจากใส่ link เป็นใส่ชื่อ hook ที่สร้างไว้ใน script log ของแต่ละเจ้า
--TODO -- และใน config.function.lua ที่ Config.ServerOnSendDiscord ให้ส่งไปตามตัวอย่างได้เลย

--['ambulance'] = {
--    Name = 'หมอ',
--    Coords = vector3(339.8, -575.32, 43.32),
--    Heading = 342.16,
--    Model = 'p_v_43_safe_s',
--    NeedItemLicense = {
--        'vault_key_ambulance',
--    },
--    AllowBlackMoney = false,
--    DiscordHook = {
--        ["PutItem"]   = "vaultAmbulancePutItem", -- นำไอเท็มเข้า
--        ["PutMoney"]  = "vaultAmbulancePutMoney", -- นำเงินเข้า
--        ["PutWeapon"] = "vaultAmbulancePutWeapon", -- นำอาวุธเข้า
--        ["GetItem"]   = "vaultAmbulanceGetItem", -- นำไอเท็มออก
--        ["GetMoney"]  = "vaultAmbulanceGetMoney", -- นำเงินออก
--        ["GetWeapon"] = "vaultAmbulanceGetWeapon", -- นำอาวุธออก
--    }
--},
