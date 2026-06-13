CREATE TABLE dim_tiempo (
    tiempo_id NUMBER(10) NOT NULL,
    fecha DATE NOT NULL,
    dia NUMBER(2) NOT NULL,
    mes NUMBER(2) NOT NULL,
    trimestre NUMBER(1) NOT NULL,
    anio NUMBER(4) NOT NULL,
    dia_semana VARCHAR2(20),
    CONSTRAINT pk_dim_tiempo PRIMARY KEY (tiempo_id),
    CONSTRAINT uk_dim_tiempo_fecha UNIQUE (fecha),
    CONSTRAINT ck_dim_tiempo_dia CHECK (dia BETWEEN 1 AND 31),
    CONSTRAINT ck_dim_tiempo_mes CHECK (mes BETWEEN 1 AND 12),
    CONSTRAINT ck_dim_tiempo_trimestre CHECK (trimestre BETWEEN 1 AND 4)
);

CREATE TABLE dim_cliente (
    cliente_id NUMBER(10) NOT NULL,
    codigo_cliente VARCHAR2(50) NOT NULL,
    codigo_unico_cliente VARCHAR2(50),
    CONSTRAINT pk_dim_cliente PRIMARY KEY (cliente_id),
    CONSTRAINT uk_dim_cliente_codigo UNIQUE (codigo_cliente)
);

CREATE TABLE dim_producto (
    producto_id NUMBER(10) NOT NULL,
    codigo_producto VARCHAR2(50) NOT NULL,
    categoria VARCHAR2(100),
    peso NUMBER(10),
    CONSTRAINT pk_dim_producto PRIMARY KEY (producto_id),
    CONSTRAINT uk_dim_producto_codigo UNIQUE (codigo_producto),
    CONSTRAINT ck_dim_producto_peso CHECK (peso IS NULL OR peso >= 0)
);

CREATE TABLE dim_vendedor (
    vendedor_id NUMBER(10) NOT NULL,
    codigo_vendedor VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_dim_vendedor PRIMARY KEY (vendedor_id),
    CONSTRAINT uk_dim_vendedor_codigo UNIQUE (codigo_vendedor)
);

CREATE TABLE dim_metodo_pago (
    metodo_pago_id NUMBER(10) NOT NULL,
    tipo_pago VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_dim_metodo_pago PRIMARY KEY (metodo_pago_id),
    CONSTRAINT uk_dim_metodo_pago_tipo UNIQUE (tipo_pago)
);

CREATE TABLE dim_ubicacion (
    ubicacion_id NUMBER(10) NOT NULL,
    prefijo_postal NUMBER(10),
    ciudad VARCHAR2(100),
    estado VARCHAR2(10),
    CONSTRAINT pk_dim_ubicacion PRIMARY KEY (ubicacion_id),
    CONSTRAINT uk_dim_ubicacion UNIQUE (prefijo_postal, ciudad, estado)
);

CREATE TABLE fact_ventas (
    venta_id NUMBER(12) NOT NULL,
    codigo_orden VARCHAR2(50) NOT NULL,
    numero_item NUMBER(10) NOT NULL,
    tiempo_id NUMBER(10) NOT NULL,
    cliente_id NUMBER(10) NOT NULL,
    producto_id NUMBER(10) NOT NULL,
    vendedor_id NUMBER(10) NOT NULL,
    ubicacion_cliente_id NUMBER(10),
    ubicacion_vendedor_id NUMBER(10),
    cantidad_vendida NUMBER(10) NOT NULL,
    precio_unitario NUMBER(10,2) NOT NULL,
    valor_flete NUMBER(10,2),
    importe_total NUMBER(10,2),
    dias_entrega NUMBER(10),
    dias_estimados_entrega NUMBER(10),
    dias_retraso NUMBER(10),
    CONSTRAINT pk_fact_ventas PRIMARY KEY (venta_id),
    CONSTRAINT uk_fact_ventas_origen UNIQUE (codigo_orden, numero_item),
    CONSTRAINT fk_ventas_tiempo FOREIGN KEY (tiempo_id) REFERENCES dim_tiempo (tiempo_id),
    CONSTRAINT fk_ventas_cliente FOREIGN KEY (cliente_id) REFERENCES dim_cliente (cliente_id),
    CONSTRAINT fk_ventas_producto FOREIGN KEY (producto_id) REFERENCES dim_producto (producto_id),
    CONSTRAINT fk_ventas_vendedor FOREIGN KEY (vendedor_id) REFERENCES dim_vendedor (vendedor_id),
    CONSTRAINT fk_ventas_ubicacion_cliente FOREIGN KEY (ubicacion_cliente_id) REFERENCES dim_ubicacion (ubicacion_id),
    CONSTRAINT fk_ventas_ubicacion_vendedor FOREIGN KEY (ubicacion_vendedor_id) REFERENCES dim_ubicacion (ubicacion_id),
    CONSTRAINT ck_ventas_cantidad CHECK (cantidad_vendida >= 0),
    CONSTRAINT ck_ventas_precio CHECK (precio_unitario >= 0),
    CONSTRAINT ck_ventas_flete CHECK (valor_flete IS NULL OR valor_flete >= 0),
    CONSTRAINT ck_ventas_importe CHECK (importe_total IS NULL OR importe_total >= 0),
    CONSTRAINT ck_ventas_dias_entrega CHECK (dias_entrega IS NULL OR dias_entrega >= 0),
    CONSTRAINT ck_ventas_dias_estimados CHECK (dias_estimados_entrega IS NULL OR dias_estimados_entrega >= 0),
    CONSTRAINT ck_ventas_dias_retraso CHECK (dias_retraso IS NULL OR dias_retraso >= 0)
);

CREATE TABLE fact_pagos (
    pago_id NUMBER(12) NOT NULL,
    codigo_orden VARCHAR2(50) NOT NULL,
    secuencia_pago NUMBER(10) NOT NULL,
    tiempo_id NUMBER(10) NOT NULL,
    cliente_id NUMBER(10) NOT NULL,
    metodo_pago_id NUMBER(10) NOT NULL,
    ubicacion_cliente_id NUMBER(10),
    valor_pago NUMBER(10,2) NOT NULL,
    cantidad_cuotas NUMBER(3),
    cantidad_pagos NUMBER(10) NOT NULL,
    CONSTRAINT pk_fact_pagos PRIMARY KEY (pago_id),
    CONSTRAINT uk_fact_pagos_origen UNIQUE (codigo_orden, secuencia_pago),
    CONSTRAINT fk_pagos_tiempo FOREIGN KEY (tiempo_id) REFERENCES dim_tiempo (tiempo_id),
    CONSTRAINT fk_pagos_cliente FOREIGN KEY (cliente_id) REFERENCES dim_cliente (cliente_id),
    CONSTRAINT fk_pagos_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES dim_metodo_pago (metodo_pago_id),
    CONSTRAINT fk_pagos_ubicacion_cliente FOREIGN KEY (ubicacion_cliente_id) REFERENCES dim_ubicacion (ubicacion_id),
    CONSTRAINT ck_pagos_valor CHECK (valor_pago >= 0),
    CONSTRAINT ck_pagos_cuotas CHECK (cantidad_cuotas IS NULL OR cantidad_cuotas >= 0),
    CONSTRAINT ck_pagos_cantidad CHECK (cantidad_pagos >= 0)
);

CREATE TABLE fact_resenas (
    resena_id NUMBER(12) NOT NULL,
    codigo_resena VARCHAR2(50) NOT NULL,
    codigo_orden VARCHAR2(50) NOT NULL,
    tiempo_id NUMBER(10) NOT NULL,
    cliente_id NUMBER(10) NOT NULL,
    ubicacion_cliente_id NUMBER(10),
    puntaje_resena NUMBER(1) NOT NULL,
    cantidad_resenas NUMBER(10) NOT NULL,
    dias_respuesta NUMBER(10),
    CONSTRAINT pk_fact_resenas PRIMARY KEY (resena_id),
    CONSTRAINT uk_fact_resenas_origen UNIQUE (codigo_resena, codigo_orden),
    CONSTRAINT fk_resenas_tiempo FOREIGN KEY (tiempo_id) REFERENCES dim_tiempo (tiempo_id),
    CONSTRAINT fk_resenas_cliente FOREIGN KEY (cliente_id) REFERENCES dim_cliente (cliente_id),
    CONSTRAINT fk_resenas_ubicacion_cliente FOREIGN KEY (ubicacion_cliente_id) REFERENCES dim_ubicacion (ubicacion_id),
    CONSTRAINT ck_resenas_puntaje CHECK (puntaje_resena BETWEEN 1 AND 5),
    CONSTRAINT ck_resenas_cantidad CHECK (cantidad_resenas >= 0),
    CONSTRAINT ck_resenas_dias CHECK (dias_respuesta IS NULL OR dias_respuesta >= 0)
);