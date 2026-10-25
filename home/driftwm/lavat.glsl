precision mediump float;

varying vec2 v_coords;
uniform vec2 size;
uniform vec2 u_camera;
uniform float u_time;
uniform float u_zoom; // Оставляем на случай, если захотите привязать зум

// Псевдослучайная функция для генерации капель по всему бесконечному холсту
vec2 random2(vec2 st) {
    st = vec2(dot(st, vec2(127.1, 311.7)),
              dot(st, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(st) * 43758.5453123);
}

// Функция плавного минимума для слияния капель
float smin(float a, float b, float k) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

void main() {
    // 1. Получаем координаты пикселя на бесконечном холсте с учетом движения камеры
    vec2 canvasCoord = v_coords * size + u_camera;
    
    // 2. Фиксированный масштаб сетки (не умножаем на u_zoom, чтобы лава жила 
    // в том же пространстве масштаба, что и ваши окна)
    float scale = 300.0; 
    vec2 uv = canvasCoord / scale;
    
    // 3. Разбиваем бесконечный холст на сетку ячеек
    vec2 i_st = floor(uv);
    vec2 f_st = fract(uv);
    
    float d = 10.0;
    
    // Проверяем текущую ячейку и соседние для бесшовного слияния капель везде
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            
            vec2 offset = random2(i_st + neighbor);
            offset = 0.5 + 0.4 * sin(u_time * 0.6 + 6.2831 * offset);
            
            vec2 pos = neighbor + offset - f_st;
            
            float dist = length(pos);
            float radius = 0.25 + 0.1 * sin(u_time * 0.5 + dot(i_st + neighbor, vec2(1.0)));
            
            d = smin(d, dist - radius, 0.3);
        }
    }
    
    // Цветовая палитра лавовой лампы
    vec3 bgColor = vec3(0.06, 0.02, 0.1);       // Глубокий темно-фиолетовый фон
    vec3 lavaColor1 = vec3(1.0, 0.15, 0.02);    // Ярко-красный
    vec3 lavaColor2 = vec3(1.0, 0.65, 0.05);    // Теплый оранжевый
    
    // Плавный градиент по высоте экрана
    float colorMix = smoothstep(-1.0, 1.0, (v_coords.y - 0.5) + sin(u_time * 0.2) * 0.2);
    vec3 currentLavaColor = mix(lavaColor1, lavaColor2, colorMix);
    
    // Отрисовка границ капель со сглаживанием
    float edge = smoothstep(-0.03, 0.03, d);
    vec3 color = mix(currentLavaColor, bgColor, edge);
    
    // Внутреннее свечение по контуру капель
    float glow = 1.0 - smoothstep(0.0, 0.35, abs(d));
    color += glow * currentLavaColor * 0.4;
    
    // Легкое затемнение по краям (виньетка)
    color *= 1.0 - 0.25 * length(v_coords - 0.5);

    gl_FragColor = vec4(color, 1.0);
}
