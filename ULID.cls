public with sharing class ULID {
    private final List<String> ENCODING = new List<String>{  '0','1','2','3','4','5','6','7','8','9',
                                                'A','B','C','D','E','F','G','H','J','K',
                                                'M','N','P','Q','R','S','T','V','W','X',
                                                'Y','Z'};
    private final Long ENCODING_LENGTH = 32;

    public String getValue() {
        return encodeTime((Long)Datetime.now().getTime(), 10) + encodeRandom(16);
    }

    private String encodeTime(Long timeNow, Long length) {
        String out = '';
        while(length > 0) {
            Integer remainder = (Integer)Math.mod(timeNow, ENCODING_LENGTH);

            out = ENCODING[remainder] + out;
            timeNow = (timeNow - remainder) / ENCODING_LENGTH;
            length--;
        }
        return out;
    }

    private String encodeRandom(Long length) {
        String out = '';
        while(length > 0) {
            Integer rand = (Integer)(Math.floor(ENCODING_LENGTH * generateRandomSecureDouble()));
            out = ENCODING[rand] + out;
            length--;
        }
        return out;
    }

    private double generateRandomSecureDouble() {
        Long maxValue = 9223372036854775807L;
        Double secureRandomDouble = (Double)Math.abs(Crypto.getRandomLong()) * 1.0 / maxValue;
        return secureRandomDouble;
    }

}
