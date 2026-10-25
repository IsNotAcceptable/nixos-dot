// Dot grid background — evenly spaced dots that scroll with the canvas.
// Zoom is handled externally (RescaleRenderElement) — shader works in canvas space.
// Edit colors, spacing, and dot size directly here.
precision mediump float;

varying vec2 v_coords;
uniform vec2 size;
uniform float alpha;

uniform vec2 u_camera;
uniform float u_time;

// --- Tweak these ---
const vec4 BG_COLOR_1 = vec4(0.02, 0.02, 0.05, 1.0);
const vec4 BG_COLOR_2 = vec4(0.08, 0.04, 0.12, 1.0);
const vec3 DOT_COLOR_BASE = vec3(0.4, 0.6, 1.0);
const vec3 DOT_COLOR_GLOW = vec3(1.0, 0.3, 0.7);
const float DOT_SPACING = 80.0; // canvas pixels between dots
const float DOT_RADIUS = 1.0; // dot radius in canvas pixels
// -------------------

void main() {
    // Screen pixel position -> canvas position
    vec2 screen_pixel = v_coords * size;
    vec2 canvas_pos = screen_pixel + mod(u_camera, DOT_SPACING);
    vec2 center_uv = v_coords - 0.5;

    float vignette = length(center_uv);
    vec4 bg_color = mix(BG_COLOR_1, BG_COLOR_2, sin(u_time * 0.5) * 0.5 + 0.5);
    bg_color.rgb -= vignette * 0.15;

    vec2 grid_cell = floor(canvas_pos / DOT_SPACING);
    vec2 grid = mod(canvas_pos, DOT_SPACING);
    vec2 dist = min(grid, DOT_SPACING - grid);
    float d = length(dist);

    float cell_hash = sin(dot(grid_cell, vec2(12.9898, 78.233))) * 43758.5453;
    float pulse = sin(u_time * 2.0 + fract(cell_hash) * 6.28) * 0.5 + 0.5;
    
    float current_radius = DOT_RADIUS + pulse * 0.8;

    float wave_pos = mod(u_time * 120.0, size.x + size.y);
    float wave_dist = abs((screen_pixel.x + screen_pixel.y) - wave_pos);
    float wave_intensity = smoothstep(180.0, 0.0, wave_dist);

    vec3 final_dot_color = mix(DOT_COLOR_BASE, DOT_COLOR_GLOW, wave_intensity + pulse * 0.3);

    float dot_alpha = 1.0 - smoothstep(current_radius - 0.5, current_radius + 0.5, d);
    float glow = exp(-d * 0.3) * (0.2 + wave_intensity * 0.5);
    vec3 color = mix(bg_color.rgb, final_dot_color, dot_alpha);
    color += final_dot_color * glow * dot_alpha;

    gl_FragColor = vec4(color, bg_color.a) * alpha;
}
