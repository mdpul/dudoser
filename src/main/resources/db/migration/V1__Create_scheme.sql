create schema if not exists dudos;

create table dudos.last_event_id
(
  id int not null,
  event_id bigint,
  constraint event_pkey primary key (id)
);

-- Table: dudos.merchant_shop_template_types

CREATE TABLE dudos.merchant_shop_template_types
(
    id smallint NOT NULL,
    code character varying(100) NOT NULL,
    description character varying(300),
    CONSTRAINT pk_merch_shop_templ_types PRIMARY KEY (id)
);

COMMENT ON TABLE dudos.merchant_shop_template_types
    IS 'Types of messages (for examle "invoice status changed", "payment started")';

-- Table: dudos.templates

CREATE TABLE dudos.templates
(
    id bigint NOT NULL,
    code character varying(50),
    body text,
    CONSTRAINT pk_templates PRIMARY KEY (id)
);

COMMENT ON TABLE dudos.templates
    IS 'Table with templates for messages';

-- Table: dudos.merchant_shop_bind

CREATE TABLE dudos.merchant_shop_bind
(
    id bigint NOT NULL,
    merch_id character varying(50),
    shop_id character varying(50),
    template_id bigint NOT NULL,
    type smallint NOT NULL,
    CONSTRAINT pk_merch_shop_bind PRIMARY KEY (id),
    CONSTRAINT fk_merch_templates FOREIGN KEY (template_id)
        REFERENCES dudos.templates (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_merch_types FOREIGN KEY (type)
        REFERENCES dudos.merchant_shop_template_types (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE SEQUENCE dudos.payment_payer_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;
-- Table: dudos.payment_payer

-- DROP TABLE dudos.payment_payer;

CREATE TABLE dudos.payment_payer
(
    id bigint NOT NULL DEFAULT nextval('dudos.payment_payer_id_seq'::regclass),
    invoice_id character varying,
    amount numeric,
    currency character varying,
    card_type character varying,
    card_mask_pan character varying,
    date character varying,
    to_receiver character varying,
    CONSTRAINT payment_payer_pkey PRIMARY KEY (id)
);

COMMENT ON TABLE dudos.payment_payer
    IS 'Table for saving payment info';
COMMENT ON TABLE dudos.merchant_shop_bind
    IS 'Binding merchant shops with templates';
COMMENT ON CONSTRAINT fk_merch_templates ON dudos.merchant_shop_bind
    IS 'Binding merch_shop.template_id toReceiver templates.id';
COMMENT ON CONSTRAINT fk_merch_types ON dudos.merchant_shop_bind
    IS 'Binding with template types';

insert into dudos.last_event_id (id, event_id) values (1, 1);

insert into dudos.merchant_shop_template_types(id, code, description) values(1, 'PAYMENT.STARTED', 'Инициация платежа');
insert into dudos.merchant_shop_template_types(id, code, description) values(2, 'INVOICE.STATUS.CHANGED', 'Изменение статуса платежа');

insert into dudos.templates (id, body) values (1, convert_from(decode('PHRhYmxlIGNlbGxwYWRkaW5nPSIwIiBjZWxsc3BhY2luZz0iMCIgYWxpZ249ImNlbnRlciI+DQogICAgPHRyPg0KICAgICAgICA8dGQgd2lkdGg9IjQ4MCIgYWxpZ249ImxlZnQiIHZhbGlnbj0idG9wIiBzdHlsZT0iYmFja2dyb3VuZDogI2ZmZmZmZjsgZm9udC1mYW1pbHk6IFRhaG9tYSwgQXJpYWwsIHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTRweDsgbGluZS1oZWlnaHQ6IDE4cHg7IGNvbG9yOiAjMDAwMDAxOyI+DQogICAgICAgICAgICA8dGFibGUgY2VsbHBhZGRpbmc9IjAiIGNlbGxzcGFjaW5nPSIwIiBzdHlsZT0icGFkZGluZzogNTBweCAyNXB4IDEwcHg7IGJhY2tncm91bmQ6ICM0YmE1NWU7IGNvbG9yOiAjZmZmZmZmOyBmb250LXNpemU6IDI2cHg7IGZvbnQtd2VpZ2h0OiBib2xkOyI+DQogICAgICAgICAgICAgICAgPHRyPg0KICAgICAgICAgICAgICAgICAgICA8dGQgd2lkdGg9IjQ4MCIgc3R5bGU9ImZvbnQtZmFtaWx5OiBIZWx2ZXRpY2EsIHNhbnMtc2VyaWY7Ij4NCiAgICAgICAgICAgICAgICAgICAgICAgIFJCS21vbmV5DQogICAgICAgICAgICAgICAgICAgIDwvdGQ+DQogICAgICAgICAgICAgICAgPC90cj4NCiAgICAgICAgICAgIDwvdGFibGU+DQogICAgICAgICAgICA8dGFibGUgY2VsbHBhZGRpbmc9IjAiIGNlbGxzcGFjaW5nPSIwIiBhbGlnbj0iY2VudGVyIiBzdHlsZT0icGFkZGluZzogMzBweCAyNXB4IDIwcHg7IHRleHQtYWxpZ246IGNlbnRlcjsgY29sb3I6ICM0YmE1NWU7IGZvbnQtc2l6ZTogMjRweDsgZm9udC13ZWlnaHQ6IDYwMDsgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsiPg0KICAgICAgICAgICAgICAgIDx0cj4NCiAgICAgICAgICAgICAgICAgICAgPHRkPg0KICAgICAgICAgICAgICAgICAgICAgICAg0KPQstCw0LbQsNC10LzRi9C5INC/0L7Qu9GM0LfQvtCy0LDRgtC10LvRjCENCiAgICAgICAgICAgICAgICAgICAgPC90ZD4NCiAgICAgICAgICAgICAgICA8L3RyPg0KICAgICAgICAgICAgPC90YWJsZT4NCiAgICAgICAgICAgIDx0YWJsZSBjZWxscGFkZGluZz0iMCIgY2VsbHNwYWNpbmc9IjAiIHN0eWxlPSJwYWRkaW5nOiAwIDI1cHg7IGZvbnQtc2l6ZTogMjVweDsgbGluZS1oZWlnaHQ6IDMwcHg7Ij4NCiAgICAgICAgICAgICAgICA8dHI+DQogICAgICAgICAgICAgICAgICAgIDx0ZCBzdHlsZT0icGFkZGluZy10b3A6IDA7IHBhZGRpbmctYm90dG9tOiAwOyI+DQogICAgICAgICAgICAgICAgICAgICAgICDQktCw0Ygg0YHRh9C10YIg0Log0L7Qv9C70LDRgtC1Og0KICAgICAgICAgICAgICAgICAgICA8L3RkPg0KICAgICAgICAgICAgICAgIDwvdHI+DQogICAgICAgICAgICAgICAgPHRyPg0KICAgICAgICAgICAgICAgICAgICA8dGQgc3R5bGU9InBhZGRpbmctdG9wOiAwOyBwYWRkaW5nLWJvdHRvbTogMDsgZm9udC13ZWlnaHQ6IGJvbGQ7Ij4NCiAgICAgICAgICAgICAgICAgICAgICAgIE5vJm5ic3A7JHtwYXltZW50UGF5ZXIuaW52b2ljZUlkfSDQvtGCJm5ic3A7JHtwYXltZW50UGF5ZXIuZGF0ZX0NCiAgICAgICAgICAgICAgICAgICAgPC90ZD4NCiAgICAgICAgICAgICAgICA8L3RyPg0KICAgICAgICAgICAgICAgIDx0cj4NCiAgICAgICAgICAgICAgICAgICAgPHRkIHN0eWxlPSJwYWRkaW5nLXRvcDogMTBweDsiPg0KICAgICAgICAgICAgICAgICAgICAgICAg0KHRg9C80LzQsCDQuiDQvtC/0LvQsNGC0LU6IDxzcGFuIHN0eWxlPSJmb250LXdlaWdodDogYm9sZDsiPiR7cGF5bWVudFBheWVyLmFtb3VudFdpdGhDdXJyZW5jeX08L3NwYW4+DQogICAgICAgICAgICAgICAgICAgIDwvdGQ+DQogICAgICAgICAgICAgICAgPC90cj4NCiAgICAgICAgICAgIDwvdGFibGU+DQogICAgICAgICAgICA8dGFibGUgY2VsbHBhZGRpbmc9IjAiIGNlbGxzcGFjaW5nPSIwIiBzdHlsZT0icGFkZGluZzogMzBweCAyNXB4IDIwcHg7Ij4NCiAgICAgICAgICAgICAgICA8dHI+DQogICAgICAgICAgICAgICAgICAgIDx0ZD4NCiAgICAgICAgICAgICAgICAgICAgICAgIDx0YWJsZSBjZWxscGFkZGluZz0iMCIgY2VsbHNwYWNpbmc9IjAiIHN0eWxlPSJwYWRkaW5nOiAxMHB4IDA7IGZvbnQtc2l6ZTogMjBweDsgZm9udC13ZWlnaHQ6IDYwMDsgY29sb3I6ICMwMDQ5MjQ7Ij4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICA8dHI+DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDx0ZD4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgINCg0LXQutC+0LzQtdC90LTQvtCy0LDQvdC90YvQtSDRgdC/0L7RgdC+0LHRiyDQvtC/0LvQsNGC0Ys6DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvdGQ+DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgPC90cj4NCiAgICAgICAgICAgICAgICAgICAgICAgIDwvdGFibGU+DQogICAgICAgICAgICAgICAgICAgICAgICA8dGFibGUgY2VsbHBhZGRpbmc9IjAiIGNlbGxzcGFjaW5nPSIwIiBzdHlsZT0icGFkZGluZzogNHB4IDA7IGZvbnQtc2l6ZTogMTVweDsgZm9udC13ZWlnaHQ6IDQwMDsgY29sb3I6ICMwMjRjMjY7Ij4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICA8dHIgdmFsaWduPSJ0b3AiPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8dGQ+DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8dWwgc3R5bGU9Imxpc3Qtc3R5bGU6IGNpcmNsZTsgY29sb3I6ICMwMjRjMjY7IG1hcmdpbjogMDsgcGFkZGluZzogMCAwIDAgMjBweDsiPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDxsaSBzdHlsZT0icGFkZGluZzogM3B4IDAiPtCa0L7RiNC10LvQtdC6IFJCSyBNb25leTwvbGk+DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPGxpIHN0eWxlPSJwYWRkaW5nOiAzcHggMCI+0KHQuNGB0YLQtdC80Ysg0LTQtdC90LXQttC90YvRhSDQv9C10YDQtdCy0L7QtNC+0LI8L2xpPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDxsaSBzdHlsZT0icGFkZGluZzogM3B4IDAiPtCf0LvQsNGC0LXQttC90YvQtSDRgtC10YDQvNC40L3QsNC70Ys8L2xpPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDxsaSBzdHlsZT0icGFkZGluZzogM3B4IDAiPtCR0LDQvdC60L7QstGB0LrQuNC1INC/0LvQsNGC0LXQttC4PC9saT4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8bGkgc3R5bGU9InBhZGRpbmc6IDNweCAwIj7QkdCw0L3QutC+0LzQsNGC0Ys8L2xpPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDxsaSBzdHlsZT0icGFkZGluZzogM3B4IDAiPtCY0L3RgtC10YDQvdC10YIg0LHQsNC90LrQuNC90LM8L2xpPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDxsaSBzdHlsZT0icGFkZGluZzogM3B4IDAiPtCR0LDQvdC60L7QstGB0LrQsNGPINC60LDRgNGC0LAgVmlzYS9NYXN0ZXJDYXJkPC9saT4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8bGkgc3R5bGU9InBhZGRpbmc6IDNweCAwIj7QodCw0LvQvtC90Ysg0YHQstGP0LfQuCDQldCy0YDQvtGB0LXRgtGMPC9saT4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8bGkgc3R5bGU9InBhZGRpbmc6IDNweCAwIj7QodCw0LvQvtC90Ysg0YHQvtGC0L7QstC+0Lkg0YHQstGP0LfQuDwvbGk+DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPGxpIHN0eWxlPSJwYWRkaW5nOiAzcHggMCI+0J/QvtC00YDQvtCx0L3QviDQvtC30L3QsNC60L7QvNC40YLRjNGB0Y8g0YHQviDQstGB0LXQvNC4INCy0L7Qt9C80L7QttC90YvQvNC4INGB0L/QvtGB0L7QsdCw0LzQuCDQvtC/0LvQsNGC0Ysg0LzQvtC20L3QviA8YSBocmVmPSJodHRwOi8vd3d3LnJia21vbmV5LmNvbS9wYXltZW50cyIgdGFyZ2V0PSJfYmxhbmsiIHN0eWxlPSJjb2xvcjogIzAyNGMyNjsgdGV4dC1kZWNvcmF0aW9uOiB1bmRlcmxpbmU7Ij7Qt9C00LXRgdGMPC9hPjwvbGk+DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3VsPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3RkPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvdHI+DQogICAgICAgICAgICAgICAgICAgICAgICA8L3RhYmxlPg0KICAgICAgICAgICAgICAgICAgICA8L3RkPg0KICAgICAgICAgICAgICAgIDwvdHI+DQogICAgICAgICAgICA8L3RhYmxlPg0KICAgICAgICAgICAgPHRhYmxlIGNlbGxwYWRkaW5nPSIwIiBjZWxsc3BhY2luZz0iMCIgc3R5bGU9InBhZGRpbmc6IDEwcHggMjVweDsgZm9udC1zaXplOiAxNHB4OyBjb2xvcjogIzRiYTU1ZTsiPg0KICAgICAgICAgICAgICAgIDx0cj4NCiAgICAgICAgICAgICAgICAgICAgPHRkPg0KICAgICAgICAgICAgICAgICAgICAgICAg0J/QviDQstGB0LXQvCDQstC+0L/RgNC+0YHQsNC8INCy0Ysg0LzQvtC20LXRgtC1INC+0LHRgNCw0YnQsNGC0YzRgdGPINC60YDRg9Cz0LvQvtGB0YPRgtC+0YfQvdC+INCyJm5ic3A70L3QsNGI0YMgPGEgaHJlZj0iaHR0cDovL3d3dy5yYmttb25leS5jb20vc3VwcG9ydCIgdGFyZ2V0PSJfYmxhbmsiIHN0eWxlPSJjb2xvcjogIzRiYTU1ZTsiPtGB0LvRg9C20LHRgyDQv9C+0LTQtNC10YDQttC60Lg8L2E+Lg0KICAgICAgICAgICAgICAgICAgICA8L3RkPg0KICAgICAgICAgICAgICAgIDwvdHI+DQogICAgICAgICAgICAgICAgPHRyIGFsaWduPSJyaWdodCI+DQogICAgICAgICAgICAgICAgICAgIDx0ZCBzdHlsZT0icGFkZGluZy10b3A6IDEwcHg7IGZvbnQtc3R5bGU6IGl0YWxpYzsiPg0KICAgICAgICAgICAgICAgICAgICAgICAg0JrQvtC80LDQvdC00LAgUkJLbW9uZXkNCiAgICAgICAgICAgICAgICAgICAgPC90ZD4NCiAgICAgICAgICAgICAgICA8L3RyPg0KICAgICAgICAgICAgPC90YWJsZT4NCiAgICAgICAgICAgIDx0YWJsZSBjZWxscGFkZGluZz0iMCIgY2VsbHNwYWNpbmc9IjAiIHN0eWxlPSJwYWRkaW5nOiAyMHB4IDI1cHg7IGZvbnQtc2l6ZTogMTFweDsgbGluZS1oZWlnaHQ6IDE0cHg7IGNvbG9yOiAjNGJhNTVlOyI+DQogICAgICAgICAgICAgICAgPHRyPg0KICAgICAgICAgICAgICAgICAgICA8dGQgc3R5bGU9InBhZGRpbmctdG9wOiAwOyBwYWRkaW5nLWJvdHRvbTogMDsiPg0KICAgICAgICAgICAgICAgICAgICAgICAg0J7Qv9C10YDQsNGC0L7RgCDQv9C+INC/0LXRgNC10LLQvtC00YMg0LTQtdC90LXQttC90YvRhSDRgdGA0LXQtNGB0YLQsg0KICAgICAgICAgICAgICAgICAgICA8L3RkPg0KICAgICAgICAgICAgICAgIDwvdHI+DQogICAgICAgICAgICAgICAgPHRyPg0KICAgICAgICAgICAgICAgICAgICA8dGQgc3R5bGU9InBhZGRpbmctdG9wOiAwOyBwYWRkaW5nLWJvdHRvbTogMDsiPg0KICAgICAgICAgICAgICAgICAgICAgICAg0J3QmtCeICLQrdCf0KEiICjQntCe0J4pICjQu9C40YbQtdC90LfQuNGPINCR0LDQvdC60LAg0KDQvtGB0YHQuNC4IE5vMzUwOS1LINC+0YImbmJzcDsxMS4wMi4yMDEz0LMuKQ0KICAgICAgICAgICAgICAgICAgICA8L3RkPg0KICAgICAgICAgICAgICAgIDwvdHI+DQogICAgICAgICAgICAgICAgPHRyPg0KICAgICAgICAgICAgICAgICAgICA8dGQgc3R5bGU9InBhZGRpbmctdG9wOiAwOyBwYWRkaW5nLWJvdHRvbTogMDsiPg0KICAgICAgICAgICAgICAgICAgICAgICAgPGEgaHJlZj0iaHR0cDovL3d3dy5uY28tZXBzLnJ1IiB0YXJnZXQ9Il9ibGFuayIgc3R5bGU9ImZvbnQtc2l6ZTogMTNweDsgZm9udC13ZWlnaHQ6IDYwMDsgZm9udC1zdHlsZTogaXRhbGljOyBjb2xvcjogIzRiYTU1ZTsgdGV4dC1kZWNvcmF0aW9uOiBub25lOyI+d3d3Lm5jby1lcHMucnU8L2E+DQogICAgICAgICAgICAgICAgICAgIDwvdGQ+DQogICAgICAgICAgICAgICAgPC90cj4NCiAgICAgICAgICAgIDwvdGFibGU+DQogICAgICAgIDwvdGQ+DQogICAgPC90cj4NCjwvdGFibGU+DQo=', 'base64'), 'UTF8'));
insert into dudos.templates (id, body) values (2, convert_from(decode('PHRhYmxlIGNlbGxwYWRkaW5nPSIwIiBjZWxsc3BhY2luZz0iMCIgYWxpZ249ImNlbnRlciI+DQogICAgPHRyPg0KICAgICAgICA8dGQgd2lkdGg9IjQ4MCIgYWxpZ249ImxlZnQiIHZhbGlnbj0idG9wIiBzdHlsZT0iYmFja2dyb3VuZDogI2ZmZmZmZjsgZm9udC1mYW1pbHk6IFRhaG9tYSwgQXJpYWwsIHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTRweDsgbGluZS1oZWlnaHQ6IDE4cHg7IGNvbG9yOiAjMDAwMDAxOyI+DQogICAgICAgICAgICA8dGFibGUgY2VsbHBhZGRpbmc9IjAiIGNlbGxzcGFjaW5nPSIwIiBzdHlsZT0icGFkZGluZzogNTBweCAyNXB4IDEwcHg7IGJhY2tncm91bmQ6ICM0YmE1NWU7IGNvbG9yOiAjZmZmZmZmOyBmb250LXNpemU6IDI2cHg7IGZvbnQtd2VpZ2h0OiBib2xkOyI+DQogICAgICAgICAgICAgICAgPHRyPg0KICAgICAgICAgICAgICAgICAgICA8dGQgd2lkdGg9IjQ4MCIgc3R5bGU9ImZvbnQtZmFtaWx5OiBIZWx2ZXRpY2EsIHNhbnMtc2VyaWY7Ij4NCiAgICAgICAgICAgICAgICAgICAgICAgIFJCS21vbmV5DQogICAgICAgICAgICAgICAgICAgIDwvdGQ+DQogICAgICAgICAgICAgICAgPC90cj4NCiAgICAgICAgICAgIDwvdGFibGU+DQogICAgICAgICAgICA8dGFibGUgY2VsbHBhZGRpbmc9IjAiIGNlbGxzcGFjaW5nPSIwIiBhbGlnbj0iY2VudGVyIiBzdHlsZT0icGFkZGluZzogMzBweCAyNXB4IDIwcHg7IHRleHQtYWxpZ246IGNlbnRlcjsgY29sb3I6ICM0YmE1NWU7IGZvbnQtc2l6ZTogMjRweDsgZm9udC13ZWlnaHQ6IDYwMDsgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsiPg0KICAgICAgICAgICAgICAgIDx0cj4NCiAgICAgICAgICAgICAgICAgICAgPHRkPg0KICAgICAgICAgICAgICAgICAgICAgICAg0KPQstCw0LbQsNC10LzRi9C5INC/0L7Qu9GM0LfQvtCy0LDRgtC10LvRjCENCiAgICAgICAgICAgICAgICAgICAgPC90ZD4NCiAgICAgICAgICAgICAgICA8L3RyPg0KICAgICAgICAgICAgPC90YWJsZT4NCiAgICAgICAgICAgIDx0YWJsZSBjZWxscGFkZGluZz0iMCIgY2VsbHNwYWNpbmc9IjAiIHN0eWxlPSJwYWRkaW5nOiAwIDI1cHg7IGZvbnQtc2l6ZTogMjBweDsgbGluZS1oZWlnaHQ6IDI0cHg7Ij4NCiAgICAgICAgICAgICAgICA8dHI+DQogICAgICAgICAgICAgICAgICAgIDx0ZCBzdHlsZT0icGFkZGluZy10b3A6IDA7IHBhZGRpbmctYm90dG9tOiAwOyI+DQogICAgICAgICAgICAgICAgICAgICAgICDQktGLINC+0YHRg9GJ0LXRgdGC0LLQuNC70Lgg0L/Qu9Cw0YLQtdC2DQogICAgICAgICAgICAgICAgICAgIDwvdGQ+DQogICAgICAgICAgICAgICAgPC90cj4NCiAgICAgICAgICAgICAgICA8dHI+DQogICAgICAgICAgICAgICAgICAgIDx0ZCBzdHlsZT0icGFkZGluZy10b3A6IDA7Ij4NCiAgICAgICAgICAgICAgICAgICAgICAgINC90LAg0YHRg9C80LzRgzogJHtwYXltZW50UGF5ZXIuYW1vdW50V2l0aEN1cnJlbmN5fQ0KICAgICAgICAgICAgICAgICAgICA8L3RkPg0KICAgICAgICAgICAgICAgIDwvdHI+DQogICAgICAgICAgICAgICAgPHRyPg0KICAgICAgICAgICAgICAgICAgICA8dGQgc3R5bGU9InBhZGRpbmctdG9wOiAwOyBwYWRkaW5nLWJvdHRvbTogMDsgZm9udC13ZWlnaHQ6IGJvbGQ7Ij4NCiAgICAgICAgICAgICAgICAgICAgICAgINC/0L4g0YHRh9C10YLRgyBObyZuYnNwOyR7cGF5bWVudFBheWVyLmludm9pY2VJZH0g0L7RgiZuYnNwOyR7cGF5bWVudFBheWVyLmRhdGV9DQogICAgICAgICAgICAgICAgICAgIDwvdGQ+DQogICAgICAgICAgICAgICAgPC90cj4NCiAgICAgICAgICAgIDwvdGFibGU+DQogICAgICAgICAgICA8dGFibGUgY2VsbHBhZGRpbmc9IjAiIGNlbGxzcGFjaW5nPSIwIiBzdHlsZT0icGFkZGluZzogMjBweCAyNXB4OyBmb250LXNpemU6IDE2cHg7IGxpbmUtaGVpZ2h0OiAyMHB4OyI+DQogICAgICAgICAgICAgICAgPHRyPg0KICAgICAgICAgICAgICAgICAgICA8dGQgc3R5bGU9InBhZGRpbmctdG9wOiA1cHg7IHBhZGRpbmctYm90dG9tOiA1cHg7Ij4NCiAgICAgICAgICAgICAgICAgICAgICAgINCi0LjQvyDQutCw0YDRgtGLOiAke3BheW1lbnRQYXllci5jYXJkVHlwZX0NCiAgICAgICAgICAgICAgICAgICAgPC90ZD4NCiAgICAgICAgICAgICAgICA8L3RyPg0KICAgICAgICAgICAgICAgIDx0cj4NCiAgICAgICAgICAgICAgICAgICAgPHRkIHN0eWxlPSJwYWRkaW5nLXRvcDogNXB4OyBwYWRkaW5nLWJvdHRvbTogNXB4OyI+DQogICAgICAgICAgICAgICAgICAgICAgICDQnNCw0YHQutC40YDQvtCy0LDQvdC90LDRjyDQutCw0YDRgtCwOiAke3BheW1lbnRQYXllci5jYXJkTWFza1Bhbn0NCiAgICAgICAgICAgICAgICAgICAgPC90ZD4NCiAgICAgICAgICAgICAgICA8L3RyPg0KICAgICAgICAgICAgICAgIDx0cj4NCiAgICAgICAgICAgICAgICAgICAgPHRkIHN0eWxlPSJwYWRkaW5nLXRvcDogNXB4OyBwYWRkaW5nLWJvdHRvbTogNXB4OyI+DQogICAgICAgICAgICAgICAgICAgICAgICBFLW1haWw6ICR7cGF5bWVudFBheWVyLnRvUmVjZWl2ZXJ9DQogICAgICAgICAgICAgICAgICAgIDwvdGQ+DQogICAgICAgICAgICAgICAgPC90cj4NCiAgICAgICAgICAgIDwvdGFibGU+DQogICAgICAgICAgICA8dGFibGUgY2VsbHBhZGRpbmc9IjAiIGNlbGxzcGFjaW5nPSIwIiBzdHlsZT0icGFkZGluZzogMjBweCAyNXB4OyBmb250LXNpemU6IDE2cHg7IGxpbmUtaGVpZ2h0OiAyMHB4OyI+DQogICAgICAgICAgICAgICAgPHRyPg0KICAgICAgICAgICAgICAgICAgICA8dGQ+DQogICAgICAgICAgICAgICAgICAgICAgICDQodGH0LXRgiDQv9C+0LvQvdC+0YHRgtGM0Y4g0L7Qv9C70LDRh9C10L0NCiAgICAgICAgICAgICAgICAgICAgPC90ZD4NCiAgICAgICAgICAgICAgICA8L3RyPg0KICAgICAgICAgICAgPC90YWJsZT4NCiAgICAgICAgICAgIDx0YWJsZSBjZWxscGFkZGluZz0iMCIgY2VsbHNwYWNpbmc9IjAiIHN0eWxlPSJwYWRkaW5nOiAyMHB4IDI1cHg7IGZvbnQtc2l6ZTogMTRweDsgbGluZS1oZWlnaHQ6IDIwcHg7Ij4NCiAgICAgICAgICAgICAgICA8dHI+DQogICAgICAgICAgICAgICAgICAgIDx0ZD4NCiAgICAgICAgICAgICAgICAgICAgICAgINCV0YHQu9C4INC+0L/QtdGA0LDRhtC40Y8g0YHQvtCy0LXRgNGI0LXQvdCwINC90LUg0LLQsNC80LgsINC+0LEg0YPRgtGA0LDRgtC1INGN0LvQtdC60YLRgNC+0L3QvdC+0LPQviDQv9C70LDRgtC10LbQvdC+0LPQviDRgdGA0LXQtNGB0YLQstCwINC40LvQuCDQviDQtdCz0L4g0LjRgdC/0L7Qu9GM0LfQvtCy0LDQvdC40Lgg0LHQtdC3INCy0LDRiNC10LPQviDRgdC+0LPQu9Cw0YHQuNGPINCS0Ysg0LzQvtC20LXRgtC1INGD0LLQtdC00L7QvNC40YLRjCDQvdCw0YEg0L/QviDRgtC10LvQtdGE0L7QvdGDICs3ICg0OTUpIDY0OC02OC01OCDQuNC70Lgg0L3QsNC/0YDQsNCy0LjQsiDQvdCw0Lwg0YHQvtC+0YLQstC10YLRgdGC0LLRg9GO0YnQtdC1INGN0LvQtdC60YLRgNC+0L3QvdC+0LUg0LfQsNGP0LLQu9C10L3QuNC1INC90LAg0LHQu9C+0LrQuNGA0L7QstCw0L3QuNC1INCy0LDRiNC10LPQviDRjdC70LXQutGC0YDQvtC90L3QvtCz0L4g0YHRgNC10LTRgdGC0LLQsCDQv9C70LDRgtC10LbQsCDRh9C10YDQtdC3INCh0LjRgdGC0LXQvNGDIFJCS21vbmV5DQogICAgICAgICAgICAgICAgICAgIDwvdGQ+DQogICAgICAgICAgICAgICAgPC90cj4NCiAgICAgICAgICAgIDwvdGFibGU+DQogICAgICAgICAgICA8dGFibGUgY2VsbHBhZGRpbmc9IjAiIGNlbGxzcGFjaW5nPSIwIiBzdHlsZT0icGFkZGluZzogMTBweCAyNXB4OyBmb250LXNpemU6IDE0cHg7IGNvbG9yOiAjNGJhNTVlOyI+DQogICAgICAgICAgICAgICAgPHRyPg0KICAgICAgICAgICAgICAgICAgICA8dGQ+DQogICAgICAgICAgICAgICAgICAgICAgICDQn9C+INCy0YHQtdC8INCy0L7Qv9GA0L7RgdCw0Lwg0LLRiyDQvNC+0LbQtdGC0LUg0L7QsdGA0LDRidCw0YLRjNGB0Y8g0LrRgNGD0LPQu9C+0YHRg9GC0L7Rh9C90L4g0LImbmJzcDvQvdCw0YjRgyA8YSBocmVmPSJodHRwOi8vd3d3LnJia21vbmV5LmNvbS9zdXBwb3J0IiB0YXJnZXQ9Il9ibGFuayIgc3R5bGU9ImNvbG9yOiAjNGJhNTVlOyI+0YHQu9GD0LbQsdGDINC/0L7QtNC00LXRgNC20LrQuDwvYT4uDQogICAgICAgICAgICAgICAgICAgIDwvdGQ+DQogICAgICAgICAgICAgICAgPC90cj4NCiAgICAgICAgICAgICAgICA8dHIgYWxpZ249InJpZ2h0Ij4NCiAgICAgICAgICAgICAgICAgICAgPHRkIHN0eWxlPSJwYWRkaW5nLXRvcDogMTBweDsgZm9udC1zdHlsZTogaXRhbGljOyI+DQogICAgICAgICAgICAgICAgICAgICAgICDQmtC+0LzQsNC90LTQsCBSQkttb25leQ0KICAgICAgICAgICAgICAgICAgICA8L3RkPg0KICAgICAgICAgICAgICAgIDwvdHI+DQogICAgICAgICAgICA8L3RhYmxlPg0KICAgICAgICAgICAgPHRhYmxlIGNlbGxwYWRkaW5nPSIwIiBjZWxsc3BhY2luZz0iMCIgc3R5bGU9InBhZGRpbmc6IDIwcHggMjVweDsgZm9udC1zaXplOiAxMXB4OyBsaW5lLWhlaWdodDogMTRweDsgY29sb3I6ICM0YmE1NWU7Ij4NCiAgICAgICAgICAgICAgICA8dHI+DQogICAgICAgICAgICAgICAgICAgIDx0ZCBzdHlsZT0icGFkZGluZy10b3A6IDA7IHBhZGRpbmctYm90dG9tOiAwOyI+DQogICAgICAgICAgICAgICAgICAgICAgICDQntC/0LXRgNCw0YLQvtGAINC/0L4g0L/QtdGA0LXQstC+0LTRgyDQtNC10L3QtdC20L3Ri9GFINGB0YDQtdC00YHRgtCyDQogICAgICAgICAgICAgICAgICAgIDwvdGQ+DQogICAgICAgICAgICAgICAgPC90cj4NCiAgICAgICAgICAgICAgICA8dHI+DQogICAgICAgICAgICAgICAgICAgIDx0ZCBzdHlsZT0icGFkZGluZy10b3A6IDA7IHBhZGRpbmctYm90dG9tOiAwOyI+DQogICAgICAgICAgICAgICAgICAgICAgICDQndCa0J4gItCt0J/QoSIgKNCe0J7QnikgKNC70LjRhtC10L3Qt9C40Y8g0JHQsNC90LrQsCDQoNC+0YHRgdC40LggTm8zNTA5LUsg0L7RgiZuYnNwOzExLjAyLjIwMTPQsy4pDQogICAgICAgICAgICAgICAgICAgIDwvdGQ+DQogICAgICAgICAgICAgICAgPC90cj4NCiAgICAgICAgICAgICAgICA8dHI+DQogICAgICAgICAgICAgICAgICAgIDx0ZCBzdHlsZT0icGFkZGluZy10b3A6IDA7IHBhZGRpbmctYm90dG9tOiAwOyI+DQogICAgICAgICAgICAgICAgICAgICAgICA8YSBocmVmPSJodHRwOi8vd3d3Lm5jby1lcHMucnUiIHRhcmdldD0iX2JsYW5rIiBzdHlsZT0iZm9udC1zaXplOiAxM3B4OyBmb250LXdlaWdodDogNjAwOyBmb250LXN0eWxlOiBpdGFsaWM7IGNvbG9yOiAjNGJhNTVlOyB0ZXh0LWRlY29yYXRpb246IG5vbmU7Ij53d3cubmNvLWVwYy5ydTwvYT4NCiAgICAgICAgICAgICAgICAgICAgPC90ZD4NCiAgICAgICAgICAgICAgICA8L3RyPg0KICAgICAgICAgICAgPC90YWJsZT4NCiAgICAgICAgPC90ZD4NCiAgICA8L3RyPg0KPC90YWJsZT4NCg==', 'base64'), 'UTF8'));

insert into dudos.merchant_shop_bind(id, type, template_id) values (1, 1, 1);
insert into dudos.merchant_shop_bind(id, type, template_id) values (2, 2, 2);
