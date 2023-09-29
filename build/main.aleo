program aleonotes.aleo;

struct NoteContent:
    part1 as field;
    part2 as field;
    part3 as field;
    part4 as field;
    part5 as field;
    part6 as field;
    part7 as field;
    part8 as field;
    part9 as field;
    part10 as field;
    part11 as field;
    part12 as field;

record Note:
    owner as address.private;
    note as NoteContent.private;
    timestamp as u64.private;
    folder_id as u64.private;

record Folder:
    owner as address.private;
    folder_id as u64.private;
    name as field.private;
    create_time as u64.private;


mapping folders:
	key left as address.public;
	value right as u64.public;

function create_folder:
    input r0 as field.private;
    input r1 as u64.private;
    input r2 as u64.private;
    cast self.caller r1 r0 r2 into r3 as Folder.record;
    output r3 as Folder.record;

    finalize self.caller r1;

finalize create_folder:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use folders[r0] 0u64 into r2;
    add r2 1u64 into r3;
    set r3 into folders[r0];


function delete_folder:
    input r0 as Folder.record;
    assert.eq self.caller r0.owner;


function new_note:
    input r0 as NoteContent.private;
    input r1 as u64.private;
    input r2 as u64.private;
    cast self.caller r0 r1 r2 into r3 as Note.record;
    output r3 as Note.record;

    finalize self.caller r2;

finalize new_note:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use folders[r0] 0u64 into r2;
    lte r1 r2 into r3;
    assert.eq r3 true;


function delete_note:
    input r0 as Note.record;
    assert.eq self.caller r0.owner;


function update_note:
    input r0 as Note.record;
    input r1 as NoteContent.private;
    input r2 as u64.private;
    cast self.caller r1 r2 r0.folder_id into r3 as Note.record;
    output r3 as Note.record;
