component singleton {

    variables.MINUTES_IN_DAY = 1440;
    variables.MINUTES_IN_ALMOST_TWO_DAYS = 2520;
    variables.MINUTES_IN_MONTH = 43200;
    variables.MINUTES_IN_TWO_MONTHS = 86400;

    public string function formatDistance(
        required date date,
        date baseDate = now(),
        boolean includeSeconds = false
    ) {
        var comparison = dateCompare( arguments.date, arguments.baseDate );

        var dateLeft = arguments.date;
        var dateRight = arguments.baseDate;
        if ( comparison < 0 ) {
            dateLeft = arguments.baseDate;
            dateRight = arguments.date;
        }

        var seconds = dateDiff( "s", dateRight, dateLeft );
        var minutes = dateDiff( "n", dateRight, dateLeft );
        var months = 0;

        // 0 up to 2 mins
        if ( minutes < 2 ) {
            if ( arguments.includeSeconds ) {
                if ( seconds < 5 ) {
                    return "less than 5 seconds";
                } else if ( seconds < 10 ) {
                    return "less than 10 seconds";
                } else if ( seconds < 20 ) {
                    return "less than 20 seconds";
                } else if ( seconds < 40 ) {
                    return "half a minute";
                } else if ( seconds < 60 ) {
                    return "less than a minute";
                } else {
                    return "1 minute";
                }
            } else {
                if ( minutes == 0 ) {
                    return "less than a minute";
                } else {
                    return minutes == 1 ? "1 minute" : "#minutes# minutes";
                }
            }
            // 2 mins up to 0.75 hrs
        } else if ( minutes < 45 ) {
            return minutes == 1 ? "a minute" : "#minutes# minutes";
            // 0.75 hrs up to 1.5 hrs
        } else if ( minutes < 90 ) {
            return "about an hour";
            // 1.5 hrs up to 24 hrs
        } else if ( minutes < variables.MINUTES_IN_DAY ) {
            var hours = round( minutes / 60 );
            return hours == 1 ? "about an hour" : "about #hours# hours";
            // 1 day up to 1.75 days
        } else if ( minutes < variables.MINUTES_IN_ALMOST_TWO_DAYS ) {
            return "a day";
            // 1.75 days up to 30 days
        } else if ( minutes < variables.MINUTES_IN_MONTH ) {
            var days = round( minutes / variables.MINUTES_IN_DAY );
            return days == 1 ? "a day" : "#days# days";
            // 1 month up to 2 months
        } else if ( minutes < variables.MINUTES_IN_TWO_MONTHS ) {
            months = round( minutes / variables.MINUTES_IN_MONTH );
            return months == 1 ? "about a month" : "about #months# months";
        }

        months = dateDiff( "m", dateRight, dateLeft );

        // 2 months up to 12 months
        if ( months < 12 ) {
            var nearestMonth = round( minutes / variables.MINUTES_IN_MONTH );
            return nearestMonth == 1 ? "a month" : "#nearestMonth# months";
            // 1 year up to max Date
        } else {
            var monthsSinceStartOfYear = months % 12;
            var years = floor( months / 12 );

            // N years up to 1 years 3 months
            if ( monthsSinceStartOfYear < 3 ) {
                return years == 1 ? "about a year" : "about #years# years";
                // N years 3 months up to N years 9 months
            } else if ( monthsSinceStartOfYear < 9 ) {
                return years == 1 ? "over a year" : "over #years# years";

                // N years 9 months up to N year 12 months
            } else {
                return "almost #years + 1# years";
            }
        }
    }

}
