external reraise : exn -> 'a = "%reraise"
let bracket create destroy f =
  let resource = create () in
  try
    let result = f resource in
    destroy resource;
    result
  with e ->
    destroy resource;
    reraise e

module Snapshot = struct
  type t
end

module Options = struct
  type t
  type _ opt_name =
    WAL_size_limit_MB : int opt_name
  | WAL_ttl_seconds : int opt_name
  (* access_hint_on_compaction_start *)
  | Advise_random_on_open : bool opt_name
  | Allow_concurrent_memtable_write : bool opt_name
  | Allow_mmap_reads : bool opt_name
  | Allow_mmap_writes : bool opt_name
  | Arena_block_size : int opt_name
  | Base_background_compactions : int opt_name
  (* block_based_table_factory *)
  | Bloom_locality : int opt_name
  (* compaction_filter *)
  (* compaction_filter_factory *)
  (* compaction_style *)
  (* comparator *)
  (* compression *)
  (* compression_options *)
  (* compression_per_level *)
  | Create_if_missing : bool opt_name
  | Create_missing_column_families : bool opt_name
  (* cuckoo_table_factory *)
  | Db_log_dir : string opt_name
  (* db_paths *)
  | Db_write_buffer_size : int opt_name
  | Delete_obsolete_files_period_micros : int opt_name
  | Disable_auto_compactions : bool (*  ?? *) opt_name
  | Enable_write_thread_adaptive_yield : bool opt_name
  (* env *)
  | Error_if_exists : bool opt_name
  (* fifo_compaction_options *)
  | Hard_pending_compaction_bytes_limit : int opt_name
  | Hard_rate_limit : float opt_name
  (* hash_link_list_rep *)
  (* hash_skip_list_rep *)
  (* info_log *)
  | Info_log_level : int opt_name
  | Inplace_update_num_locks : int opt_name
  | Inplace_update_support : bool opt_name
  | Is_fd_close_on_exec : bool opt_name
  | Keep_log_file_num : int opt_name
  | Level0_file_num_compaction_trigger : int opt_name
  | Level0_slowdown_writes_trigger : int opt_name
  | Level0_stop_writes_trigger : int opt_name
  | Level_compaction_dynamic_level_bytes : bool (*  ? *) opt_name
  | Log_file_time_to_roll : int opt_name
  | Manifest_preallocation_size : int opt_name
  | Max_background_compactions : int opt_name
  | Max_background_flushes : int opt_name
  | Max_bytes_for_level_base : int opt_name
  | Max_bytes_for_level_multiplier : float opt_name
  (* max_bytes_for_level_multiplier_additional *)
  | Max_compaction_bytes : int opt_name
  | Max_file_opening_threads : int opt_name
  | Max_log_file_size : int opt_name
  | Max_manifest_file_size : int opt_name
  | Max_mem_compaction_level : int opt_name
  | Max_open_files : int opt_name
  | Max_sequential_skip_in_iterations : int opt_name
  | Max_successive_merges : int opt_name
  | Max_total_wal_size : int opt_name
  | Max_write_buffer_number : int opt_name
  | Max_write_buffer_number_to_maintain : int opt_name
  | Memtable_huge_page_size : int opt_name
  | Memtable_prefix_bloom_size_ratio : float opt_name
  (* memtable_vector_rep *)
  (* merge_operator *)
  (* min_level_to_compress *)
  | Min_write_buffer_number_to_merge : int opt_name
  | Num_levels : int opt_name
  | Optimize_filters_for_hits : bool opt_name
  | Paranoid_checks : bool opt_name
  (* plain_table_factory *)
  (* prefix_extractor *)
  | Rate_limit_delay_max_milliseconds : int opt_name
  (* ratelimiter *)
  | Recycle_log_file_num : int opt_name
  | Report_bg_io_stats : bool opt_name
  | Skip_log_error_on_recovery : bool opt_name
  | Skip_stats_update_on_db_open : bool opt_name
  | Soft_pending_compaction_bytes_limit : int opt_name
  | Soft_rate_limit : float opt_name
  | Stats_dump_period_sec : int opt_name
  | Table_cache_numshardbits : int opt_name
  | Target_file_size_base : int opt_name
  | Target_file_size_multiplier : int opt_name
  (* uint64add_merge_operator *)
  | Use_adaptive_mutex : bool opt_name
  | Use_direct_io_for_flush_and_compaction : bool opt_name
  | Use_direct_reads : bool opt_name
  | Use_fsync : bool opt_name
  | Wal_bytes_per_sync : int opt_name
  (* wal_dir *)
  | Wal_recovery_mode : int opt_name
  | Writable_file_max_buffer_size : int opt_name
  | Write_buffer_size : int opt_name
  (* rocksdb_options_increase_parallelism *)
  (* rocksdb_options_optimize_for_point_lookup *)
  (* rocksdb_options_optimize_level_style_compaction *)
  (* rocksdb_options_optimize_universal_style_compaction *)

  external create : unit -> t = "caml_rocksdb_Options_create"
  external set : t -> 'a opt_name -> 'a -> unit = "caml_rocksdb_Options_set" [@@noalloc]

  let default = create ()
end

module ReadOptions = struct
  type t
  type _ opt_name =
     Background_purge_on_iterator_cleanup : bool opt_name
   | Fill_cache : bool opt_name
   | Ignore_range_deletions : bool opt_name
   (* iterate_lower_bound *)
   (* iterate_upper_bound *)
   | Managed : bool opt_name
   | Max_skippable_internal_keys : int opt_name
   | Pin_data : bool opt_name
   | Prefix_same_as_start : bool opt_name
   | Readahead_size : int opt_name
   | Read_tier : int opt_name
   | Snapshot : Snapshot.t option opt_name
   | Tailing : bool opt_name
   | Total_order_seek : bool opt_name
   | Verify_checksums : bool opt_name

  external create : unit -> t = "caml_rocksdb_ReadOptions_create"
  external set : t -> 'a opt_name -> 'a -> unit = "caml_rocksdb_ReadOptions_create" [@@noalloc]
  let default = create ()
end

module WriteOptions = struct
  type t
  type _ opt_name =
    DisableWAL : bool opt_name
  | Ignore_missing_column_families : bool opt_name
  | Low_pri : bool opt_name
  | No_slowdown : bool opt_name
  | Sync : bool opt_name

  external create : unit -> t = "caml_rocksdb_WriteOptions_create"
  external set : t -> 'a opt_name -> 'a -> unit = "caml_rocksdb_WriteOptions_set" [@@noalloc]
  let default = create ()
end

module FlushOptions = struct
  type t
  type _ opt_name =
    Wait : bool opt_name

  external create : unit -> t = "caml_rocksdb_FlushOptions_create"
  external set : t -> 'a opt_name -> 'a -> unit = "caml_rocksdb_FlushOptions_set" [@@noalloc]
  let default = create ()
end

module TransactionOptions = struct
  type t
  type _ opt_name =
    Set_snapshot : bool opt_name
  | Deadlock_detect : bool opt_name
  | Use_only_the_last_commit_time_batch_for_recovery: bool opt_name
  | Lock_timeout : int opt_name
  | Expiration : int opt_name
  | Deadlock_detect_depth : int opt_name
  | Max_write_batch_size : int opt_name

  external create : unit -> t = "caml_rocksdb_TransactionOptions_create"
  external set : t -> 'a opt_name -> 'a -> unit
    = "caml_rocksdb_TransactionOptions_set" [@@noalloc]
  let default = create ()
end

module TransactionDBOptions = struct
  type t
    type txn_db_write_policy =
    WRITE_COMMITTED
  | WRITE_PREPARED
  | WRITE_UNPREPARED
  type _ opt_name =
    Max_num_locks : int opt_name
  | Max_num_deadlocks : int opt_name
  | Num_stripes : int opt_name
  | Transaction_lock_timeout : int opt_name
  | Default_lock_timeout : int opt_name
  | Write_policy : txn_db_write_policy opt_name
  external create : unit -> t = "caml_rocksdb_TransactionDBOptions_create"
  external set : t -> 'a opt_name -> 'a -> unit
    = "caml_rocksdb_TransactionDBOptions_set" [@@noalloc]
  let default = create ()
end

module WriteBatch = struct
  type t

  external create : unit -> t = "caml_rocksdb_WriteBatch_create"
  external clear : t -> unit = "caml_rocksdb_WriteBatch_Clear" [@@noalloc]
  external count : t -> unit = "caml_rocksdb_WriteBatch_Count" [@@noalloc]
  external data : t -> string = "caml_rocksdb_WriteBatch_Data" [@@noalloc]
  external delete : t -> string -> unit = "caml_rocksdb_WriteBatch_Delete" [@@noalloc]
  external delete_range : t -> string -> string -> unit = "caml_rocksdb_WriteBatch_DeleteRange" [@@noalloc]
  external merge : t -> string -> string -> unit = "caml_rocksdb_WriteBatch_Merge" [@@noalloc]
  external pop_savepoint : t -> unit = "caml_rocksdb_WriteBatch_PopSavePoint" [@@noalloc]
  external put : t -> string -> string -> unit = "caml_rocksdb_WriteBatch_Put" [@@noalloc]
  external put_log_data : t -> string -> unit = "caml_rocksdb_WriteBatch_PutLogData" [@@noalloc]
  external rollback_to_savepoint : t -> unit = "caml_rocksdb_WriteBatch_RollbackToSavePoint" [@@noalloc]
  external set_savepoint : t -> unit = "caml_rocksdb_WriteBatch_SetSavePoint" [@@noalloc]
  external destroy : t -> unit = "caml_rocksdb_WriteBatch_destroy" [@@noalloc]

  let with_t ~f = bracket create destroy f
end

module Iterator = struct
  type t
  external is_valid : t -> bool = "caml_rocksdb_Iterator_Valid" [@@noalloc]
  external seek_to_first : t -> unit = "caml_rocksdb_Iterator_SeekToFirst" [@@noalloc]
  external seek_to_last : t -> unit = "caml_rocksdb_Iterator_SeekToLast" [@@noalloc]
  external seek : t -> string -> unit = "caml_rocksdb_Iterator_Seek" [@@noalloc]
  external seek_for_prev : t -> string = "caml_rocksdb_Iterator_SeekForPrev" [@@noalloc]
  external next : t -> unit = "caml_rocksdb_Iterator_Next" [@@noalloc]
  external prev : t -> unit = "caml_rocksdb_Iterator_Prev" [@@noalloc]
  external key : t -> string = "caml_rocksdb_Iterator_Key"
  external value : t -> string = "caml_rocksdb_Iterator_Value"
  external error : t -> string option = "caml_rocksdb_Iterator_Status"
  (* any accesss to iteartor after [destroy] will result in SEGV *)
  external destroy : t -> unit = "caml_rocksdb_Iterator_destroy" [@@noalloc]
end


let (|||) a b = match a with
    None -> b
  | Some x -> x

module DB = struct
  type t

  external stub_open_db : Options.t -> string -> t = "caml_rocksdb_Open"
  let open_db ?options name =
  stub_open_db (options ||| Options.default) name

  external stub_open_db_for_readonly : Options.t -> string -> bool -> t =
    "caml_rocksdb_OpenForReadOnly"
  let open_db_for_readonly ?options ?(error_if_log_file_exist=false) name  =
    stub_open_db_for_readonly (options ||| Options.default)
      name error_if_log_file_exist

  external stub_flush : t -> FlushOptions.t -> unit = "caml_rocksdb_Flush"
  let flush ?flushoptions db =
    stub_flush db (flushoptions ||| FlushOptions.default)

  (* any access to db after [close] will result in SEGV *)
  external close : t -> unit = "caml_rocksdb_close"

  external stub_get : t -> ReadOptions.t -> string -> string = "caml_rocksdb_Get"
  let get db ?read_options key =
    stub_get db (read_options ||| ReadOptions.default) key

  external stub_put : t -> ReadOptions.t -> string -> string -> unit = "caml_rocksdb_Put"
  let put db ?read_options key value =
    stub_put db (read_options ||| ReadOptions.default) key value

  external stub_delete : t -> ReadOptions.t -> string -> unit = "caml_rocksdb_Delete"
  let delete db ?read_options key =
    stub_delete db (read_options ||| ReadOptions.default) key

  external stub_merge : t -> ReadOptions.t -> string -> string -> unit = "caml_rocksdb_Merge"
  let merge db ?read_options key value =
    stub_merge db (read_options ||| ReadOptions.default ) key value

  external stub_write : t -> WriteOptions.t -> WriteBatch.t -> unit = "caml_rocksdb_Write"
  let write db ?write_options batch =
    stub_write db (write_options ||| WriteOptions.default) batch

  external stub_create_iterator : t -> ReadOptions.t -> Iterator.t = "caml_rocksdb_NewIterator"
  let create_iterator ?read_options db =
    stub_create_iterator db (read_options ||| ReadOptions.default)

  let with_iterator ?read_options db ~f =
    bracket (fun () -> create_iterator ?read_options db) (Iterator.destroy) f

  external create_snapshot : t -> Snapshot.t = "caml_rocksdb_GetSnapshot"
  external release_snapshot : t -> Snapshot.t -> unit = "caml_rocksdb_ReleaseSnapshot"

  external create_checkpoint : t -> string -> int -> unit = "caml_rocksdb_CreateCheckpoint"

  external get_property : t -> string -> string = "caml_rocksdb_GetProperty"
end

module ReadOnlyDB = struct
  include DB
  let open_db = open_db_for_readonly
end


module Transaction = struct
  type t

  external set_snapshot : t -> unit = "caml_rocksdb_Transaction_SetSnapshot" [@@noalloc]
  external get_snapshot : t -> Snapshot.t = "caml_rocksdb_Transaction_GetSnapshot"
  external clear_snapshot : t -> unit = "caml_rocksdb_Transaction_ClearSnapshot" [@@noalloc]

  external prepare : t -> unit = "caml_rocksdb_Transaction_Prepare"
  external commit : t -> unit = "caml_rocksdb_Transaction_Commit"
  external rollback : t -> unit = "caml_rocksdb_Transaction_Rollback"
  external set_savepoint : t -> unit = "caml_rocksdb_Transaction_SetSavePoint"
  external rollback_to_savepoint : t -> unit = "caml_rocksdb_Transaction_RollbackToSavePoint"

  external stub_get : t -> ReadOptions.t -> string -> string = "caml_rocksdb_Transaction_Get"
  let get txn ?read_options key =
    stub_get txn (read_options ||| ReadOptions.default) key

  external stub_get_for_update : t -> ReadOptions.t -> string -> string =
    "caml_rocksdb_Transaction_GetForUpdate"
  let get_for_update txn ?read_options key =
    stub_get txn (read_options ||| ReadOptions.default) key

  external sub_get_iterator : t -> ReadOptions.t -> Iterator.t =
    "caml_rocksdb_Transaction_GetIterator"
  let get_iterator ?read_options txn =
    sub_get_iterator txn (read_options ||| ReadOptions.default)

  let with_iterator ?read_options txn ~f =
    bracket (fun () -> get_iterator ?read_options txn) (Iterator.destroy) f

  external put : t -> string -> string -> unit = "caml_rocksdb_Transaction_Put" [@@noalloc]
  external put_log_data : t -> string -> unit = "caml_rocksdb_Transaction_PutLogData" [@@noalloc]
  external delete : t -> string -> unit = "caml_rocksdb_Transaction_Delete" [@@noalloc]
  external merge : t -> string -> string -> unit = "caml_rocksdb_Transaction_Merge" [@@noalloc]
  external destroy : t -> unit = "caml_rocksdb_Transaction_destroy" [@@noalloc]
end

module TransactionDB = struct
  include DB

  external stub_open_db : Options.t -> TransactionDBOptions.t -> string -> t =
    "caml_rocksdb_TransactionDB_Open"
  let open_db ?options ?transaction_db_options name =
    stub_open_db (options ||| Options.default)
      (transaction_db_options ||| TransactionDBOptions.default) name

  external stub_begin_transaction : t -> WriteOptions.t -> TransactionOptions.t -> Transaction.t =
    "caml_rocksdb_TransactionDB_BeginTrasaction"
  let begin_transaction ?write_options ?transaction_options t =
    stub_begin_transaction t (write_options ||| WriteOptions.default)
    (transaction_options ||| TransactionOptions.default)
end
