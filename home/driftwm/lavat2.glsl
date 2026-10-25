// bg.glsl — фон «лавовая лампа» для driftwm.
// Путь: ~/.config/driftwm/bg.glsl (подключается в config.toml → [background])
//
// Всё настраивается константами ниже. Шейдер GLSL ES 1.0 — без директивы #version.
// Встроенные входы driftwm: v_coords, size, u_time (остальные не нужны).

precision highp float;

varying vec2 v_coords;
uniform vec2 size;
uniform float u_time;

// ---------- Настройки ----------
const float SPEED      = 0.12;                  // скорость движения капель
const float BLOB_SIZE  = 0.085;                 // базовый радиус капли (доля высоты экрана)
const float BLOB_JITTER= 0.035;                 // разброс размеров
const float EDGE_SOFT  = 0.06;                  // мягкость края (больше — мутнее)
const float GLOW       = 0.9;                   // сила свечения вокруг капель
const float WOBBLE     = 0.35;                  // амплитуда дрейфа по X
const float DRIFT_Y    = 0.42;                  // амплитуда подъёма/опускания по Y

const vec3 BG_TOP      = vec3(0.04, 0.02, 0.09); // фон сверху
const vec3 BG_BOTTOM   = vec3(0.13, 0.03, 0.10); // фон снизу (нагретое дно)
const vec3 BLOB_COLD   = vec3(0.95, 0.30, 0.20); // цвет капли (остывшей)
const vec3 BLOB_HOT    = vec3(1.00, 0.80, 0.30); // цвет капли (горячей, у дна)

const int   BLOBS      = 8;                     // количество капель (больше — тяжелее)

float metaball(vec2 p, vec2 c, float r) {
    vec2 d = p - c;
    return (r * r) / (dot(d, d) + 1e-5);
}

void main() {
    float aspect = size.x / size.y;
    vec2 p = vec2(v_coords.x * aspect, v_coords.y);

    float field = 0.0;
    float heat  = 0.0;

    for (int i = 0; i < BLOBS; i++) {
        float fi = float(i);
        float t  = u_time * SPEED * (0.55 + 0.11 * fi);

        // каждая капля плавает по своей эллиптической траектории
        vec2 c = vec2(
            aspect * 0.5 + sin(t * 1.3 + fi * 2.1) * aspect * WOBBLE,
            0.5 + sin(t + fi * 1.7) * DRIFT_Y * 0.5 + cos(t * 0.7 + fi) * 0.08
        );

        float r = BLOB_SIZE + BLOB_JITTER * sin(fi * 3.1 + u_time * 0.2);
        float f = metaball(p, c, r);
        field += f;

        // чем ниже капля, тем она «горячее»
        heat += f * (1.0 - c.y);
    }

    heat = clamp(heat / max(field, 1e-4), 0.0, 1.0);

    // фон: градиент сверху вниз
    vec3 bg = mix(BG_TOP, BG_BOTTOM, pow(1.0 - v_coords.y, 1.5));

    // тело капель: мягкий край по порогу поля
    float body = smoothstep(1.0 - EDGE_SOFT, 1.0 + EDGE_SOFT, field);
    vec3 blobCol = mix(BLOB_COLD, BLOB_HOT, heat);

    // свечение вокруг капель
    float glow = smoothstep(0.2, 1.0, field) * GLOW * 0.25;

    vec3 col = bg + blobCol * glow;
    col = mix(col, blobCol, body);

    // лёгкое виньетирование
    vec2 q = v_coords - 0.5;
    col *= 1.0 - dot(q, q) * 0.35;

    gl_FragColor = vec4(col, 1.0);
}
