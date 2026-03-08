---------------------------------------------------------------------------------------
-- CONFIGURACION INICIAL Y FONDO
---------------------------------------------------------------------------------------
display.setDefault("background", 0.1, 0.1, 0.2) -- Azul oscuro

---------------------------------------------------------------------------------------
-- TITULO
---------------------------------------------------------------------------------------
local titulo = display.newText({
    text = "Calculadora de IMC",
    x = display.contentCenterX,
    y = -15,
    font = native.systemFontBold,
    fontSize = 40
})

---------------------------------------------------------------------------------------
-- CAMPOS DE ENTRADA
---------------------------------------------------------------------------------------
local peso = native.newTextField(display.contentCenterX, 110, 330, 60)
peso.placeholder = "Peso (kg)"
peso.inputType = "decimal"

local altura = native.newTextField(display.contentCenterX, 190, 330, 59)
altura.placeholder = "Altura (m)"
altura.inputType = "decimal"

---------------------------------------------------------------------------------------
-- CÍRCULO
---------------------------------------------------------------------------------------
local grupoIndicador = display.newGroup()
grupoIndicador.x = display.contentCenterX
grupoIndicador.y = display.contentHeight - 150



-- El "Aro" de color (inicialmente invisible)
local aroColor = display.newCircle(grupoIndicador, 0, 0, 280)
aroColor:setFillColor(0, 0, 0, 0) -- Transparente al inicio
aroColor.strokeWidth = 12
aroColor:setStrokeColor(1, 1, 1, 0.2)

-- Texto de Categoría (Centro arriba)
local txtCategoria = display.newText({
    parent = grupoIndicador,
    text = "---",
    x = 0, y = -50,
    font = native.systemFontBold,
    fontSize = 55
})

-- Texto de IMC (Centro abajo, chiquito)
local txtIMCNum = display.newText({
    parent = grupoIndicador,
    text = "IMC: 0.0",
    x = 0, y = 29,
    font = native.systemFont,
    fontSize = 33
})

---------------------------------------------------------------------------------------
-- FUNCIONES LÓGICAS
---------------------------------------------------------------------------------------
local function calcularIMC()
    local p = tonumber(peso.text)
    local h = tonumber(altura.text)

-- 1. Validación de campos vacíos o texto no numérico
    if not p or not h then
        txtCategoria.text = "DATOS FALTANTES"
        txtCategoria:setFillColor(1, 0, 0)
        return
    end

    -- 2. Validación de VALORES REALES (Rango lógico)
    -- Peso: entre 2kg y 400kg | Altura: entre 0.4m y 2.5m
    if p < 2 or p > 400 or h < 0.4 or h > 2.5 then
        txtCategoria.text = "VALORES IRREALES"
        txtCategoria:setFillColor(1, 0.5, 0) -- Naranja
        txtIMCNum.text = "REVISAR DATOS"
        aroColor:setStrokeColor(1, 0.5, 0, 0.5)
        return
    end
    
    if not p or not h or h <= 0 then
        txtCategoria.text = "Error"
        return
    end

    local imc = p / (h * h)
    imc = math.floor(imc * 10) / 10
    
    txtIMCNum.text = "IMC: " .. imc

    -- Lógica de Colores y Mensajes
    local r, g, b
    if imc < 18.5 then
        txtCategoria.text = "BAJO PESO"
        r, g, b = 0.2, 0.6, 1 -- Azul
    elseif imc < 25 then
        txtCategoria.text = "NORMAL"
        r, g, b = 0, 0.8, 0 -- Verde
    elseif imc < 30 then
        txtCategoria.text = "SOBREPESO"
        r, g, b = 1, 0.7, 0 -- Naranja
    else
        txtCategoria.text = "OBESIDAD"
        r, g, b = 1, 0, 0 -- Rojo
    end
 

    -- Actualizar el color del aro y el texto
    aroColor:setStrokeColor(r, g, b)
    txtCategoria:setFillColor(r, g, b)
end

local function limpiar()
    peso.text = ""
    altura.text = ""
    txtCategoria.text = "---"
    txtIMCNum.text = "IMC: 0.0"
    txtCategoria:setFillColor(1)
    aroColor:setStrokeColor(1, 1, 1, 0.2)
end

---------------------------------------------------------------------------------------
-- BOTONES GRANDES (Diseño táctil)
---------------------------------------------------------------------------------------
-- Función para crear botones visuales
local function crearBoton(label, yPos, color, accion)
    local btnGroup = display.newGroup()
    
    local rect = display.newRoundedRect(btnGroup, display.contentCenterX, yPos, 200, 50, 10)
    rect:setFillColor(unpack(color))
    
    local text = display.newText({
        parent = btnGroup,
        text = label,
        x = display.contentCenterX,
        y = yPos,
        font = native.systemFontBold,
        fontSize = 20
    })
    text:setFillColor(1)
    
    btnGroup:addEventListener("tap", accion)
    return btnGroup
end

local btnCalcular = crearBoton("CALCULAR" , 270, {0, 0.5, 0.8}, calcularIMC)
local btnLimpiar = crearBoton("LIMPIAR", 340, {0.4, 0.4, 0.4}, limpiar)