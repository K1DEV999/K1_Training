--[[

    💬 Export from K1Dev => discord:[ !🧠K1Dev#2935 || ] 
	
    🐌 @Copyright K1Dev
    ☕ Thanks For Coffee Tips 

]]--


Config = {}

Config['ตั้งค่าเบื้องต้น'] = {
    Timerevive = 5, --[[ เวลาในการเกิด ]]
    Removeitem = true, --[[ ต้องการให้ลบ Item ตอนออกจาก Zone มั้ย  ## ข้อเสียคือจะลบไอเทมแม้จะมีไอเทมนั้นจะไม่ได้ซิ้อจาก Zone ]]
    Keys = "H",  --[[ คีย์กดเกิด ]]
    Version = "1.1",  --[[ เบสเวอร์ชั่นไหน 1.1 - 1.2 ]]
}
Config["เปิดหลอดโหลดตอนออกไหม"]   = false

Config['โซน'] = {

    Inzone = {  --[[ ทางเข้า Zone  ]]
        x = -1708.239990,
        y = -2912.83,
        z = 12.92,
        Blip = {
            Sprite = 115,
            Scale = 1.0,
            Colour = 1,
            Text = "ZoneEsport",
        },
    },

    Outzone = {  --[[  ทางออก Zone -1627.8800048828125, -2708.8798828125, 13.9399995803833 ]]
        x = -1627.8800,
        y = -2708.87,
        z = 12.810000,
        heading = 330.36
    },

    Shopzone = {--[[  ที่ขายของ -1624.6400146484375, -2710.659912109375, 13.82999992370605 ]]
        Model = "u_m_m_bankman",
        x = -1624.64,   
        y = -2710.6599,  
        z = 13.829,
        h = 307.39,
    },

    ZoneTrining = { 
    x = -1624.64,   
    y = -2710.6599,  
    z = 13.829,
        Size = 150,  --[[ ขนาดวง ]]
    },
}

Config['ร้านค้า'] = { 

    ['weapon_bat'] = {  --[[ ชื่อไอเทม ]]
        name = "ไม้เบส", --[[ ชื่อภาษาไทย ]]
        type = 'weapon', --[[ TYPE weapon , Item ]]
        price = 100, --[[  ราคา ]]
    },

    ['WEAPON_PISTOL'] = {
        name = "ปืนพก",
        type = 'weapon',
        price = 100,
    },

    ['weapon_golfclub'] = {
        name = "ไม้กอล์ฟ",
        type = 'weapon',
        price = 300,
    },

    ['weapon_poolcue'] = {
        name = "ไม้พลู",
        type = 'weapon',
        price = 300,
    },

    ['apple'] = {
        name = "อาหาร",
        type = 'item',
        price = 10,
    },

}



--[[ Npc ซ้อม ]]
Config["ลบNpcหลังตาย"]= 3000 -- 1000 = 1 วิ ลบ Npc หลังตาย

Config["เช็ตNpc"] = {
    zone1 = {
        model = 'mp_m_freemode_01', -- เปลี่ยน Skin ได้
        health = 200, -- เลือด ( ห้ามต่ำกว่า 100 )
        armour = 50, -- เกราะ
        remove_range = 50.0, -- ระยะที่วิ่งห่างจากจุด Spawn แล้ว Npc จะลบ
    },
    zone2 = {
        model = 'mp_m_freemode_01', -- เปลี่ยน Skin ได้
        health = 300, -- เลือด ( ห้ามต่ำกว่า 100 )
        armour = 10000, -- เกราะ
        remove_range = 50.0, -- ระยะที่วิ่งห่างจากจุด Spawn แล้ว Npc จะลบ
    }
}

Config["เช็ตจุด"] = { 
    { coords = vector3(-1605.0899658203125, -2690.64990234375, 13.92000007629394), max = 5, distance = 10, spawntime = 1000, npc = 'zone1'} --[[  หากไม่ต้องการใช้งานใมห้ลบ ออก ]]
}