trigger AccountTrigger on Account (before update) {
    switch on Trigger.operationType {
        // when BEFORE_INSERT {
        //     System.Debug('Before Insert opertion');
        // }
    
        when BEFORE_UPDATE {
            Utils.handleBeforeInsert(Trigger.new);
        }
    }
}