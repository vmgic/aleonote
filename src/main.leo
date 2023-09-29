// The 'aleonotes' program.
program aleonotes.aleo {
   
   mapping folders: address => u64;
   
    struct NoteContent {
        part1:field,
        part2:field,
        part3:field,
        part4:field,
        part5:field,
        part6:field,
        part7:field,
        part8:field,
        part9:field,
        part10:field,
        part11:field,
        part12:field,
    }

    record Note {
        owner: address,
        note:NoteContent,
        timestamp:u64,
        folder_id:u64,
    }


    record Folder {
        owner: address,
        folder_id:u64,
        name:field,
        create_time:u64,
    }


    transition create_folder (name:field,folder_id:u64,timestamp:u64) -> Folder{
        return Folder{
            owner: self.caller,
            folder_id:folder_id,
            name:name,
            create_time:timestamp,
        } then finalize(self.caller,folder_id);
    }

    finalize create_folder (account:address,folder_id:u64) {
        let folder_index : u64 = folders.get_or_use(account,0u64);
        folders.set(account,folder_index+1u64);
    }

    transition delete_folder (folder:Folder){
        assert_eq(self.caller,folder.owner);
    }



    transition new_note (note:NoteContent,timestamp:u64,folder_id:u64) -> Note {
        return Note{
            owner:self.caller,
            note:note,
            timestamp:timestamp,
            folder_id:folder_id,
        } then finalize(self.caller,folder_id);
    }

    finalize new_note (account:address,folder_id:u64) {
        let folder_index : u64 = folders.get_or_use(account,0u64);
        assert(folder_id <= folder_index);
    }


    transition delete_note (note:Note)  {
        assert_eq(self.caller,note.owner);
    }

    transition update_note (old:Note,content:NoteContent,timestamp:u64) -> Note {
        return Note{
                owner:self.caller,
                note:content,
                timestamp:timestamp,
                folder_id:old.folder_id,
            };
    }


}
