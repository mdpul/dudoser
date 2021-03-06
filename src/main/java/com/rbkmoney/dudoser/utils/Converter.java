package com.rbkmoney.dudoser.utils;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class Converter {

    public static BigDecimal longToBigDecimal(long amount) {
        return new BigDecimal(amount).movePointLeft(2);
    }

    private static SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

    public static synchronized String getFormattedDate(String date) {
        String formattedDate;
        try {
            Date dateStr = formatter.parse(date);
            formattedDate = formatter.format(dateStr);
        } catch (ParseException e) {
            formattedDate = date;
        }
        return formattedDate;
    }

    public static String getFormattedAmount(BigDecimal amount, String currency) {
        return String.format(Locale.US, "%.2f %s", amount, currency);
    }
}
