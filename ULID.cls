public without sharing class ULID {
    private static final List<String> ENCODING  = new List<String>{  '0','1','2','3','4','5','6','7','8','9',
                                                'A','B','C','D','E','F','G','H','J','K',
                                                'M','N','P','Q','R','S','T','V','W','X',
                                                'Y','Z'};
    private static final Long ENCODING_LENGTH   = 32;
    private static final Long MAX_DATE          = 281474976710655L;
    private static final Long MAX_LONG          = 9223372036854775807L;
    private static final Integer ULID_LENGTH    = 26;
    private static final String ULID_REGEX      = '[0-7][0-9A-HJKMNP-TV-Z]{25}';


    public static String getValue() {
        Long now = (Long)Datetime.now().getTime();

        if (now > MAX_DATE) {
            return 'Invalid Date. Date must be prior to Tue Aug 02 10889 05:31:50';
        }   

        String uuid = (encodeTime(now, 10) + encodeRandom(16));

        return uuid;
    }


    public static Boolean isValid(String ulidValue) {
        if(String.isBlank(ulidValue)) {
            return false;
        }
        if(ulidValue.length() != ULID_LENGTH) {
            return false;
        }

        Pattern ulidPattern = Pattern.compile(ULID_REGEX.toLowerCase());
        Matcher ulidMatcher = ulidPattern.matcher(ulidValue.toLowerCase());

        return ulidMatcher.matches();
    }

    private static String encodeTime(Long timeNow, Long length) {
        String out = '';

        while(length > 0) {
            Integer remainder = (Integer)Math.mod(timeNow, ENCODING_LENGTH);
            
            out = ENCODING[remainder] + out;
            timeNow = (timeNow - remainder) / ENCODING_LENGTH;
            length--;
        }
        
        return out;
    }

    private static String encodeRandom(Long length) {
        String out = '';
        
        while(length > 0) {
            Integer randomIndex = (Integer)(Math.floor(ENCODING_LENGTH * generateRandomSecureDouble()));
            
            out = ENCODING[randomIndex] + out;
            length--;
        }

        return out;
    }

    private static Double generateRandomSecureDouble() {
        Double secureRandomDouble = (Double)Math.abs(Crypto.getRandomLong()) * 1.0 / MAX_LONG;

        return secureRandomDouble;
    }
}
