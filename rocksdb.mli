module Snapshot : sig
  type t
end

module Options : sig
  type t
  type _ opt_name =
    WAL_size_limit_MB : int opt_name
  | WAL_ttl_seconds : int opt_name
  | Advise_random_on_open : bool opt_name
  | Allow_concurrent_memtable_write : bool opt_name
  | Allow_mmap_reads : bool opt_name
  | Allow_mmap_writes : bool opt_name
  | Arena_block_size : int opt_name
  | Base_background_compactions : int opt_name
  | Bloom_locality : int opt_name
  | Create_if_missing : bool opt_name
  | Create_missing_column_families : bool opt_name
  | Db_log_dir : string opt_name
  | Db_write_buffer_size : int opt_name
  | Delete_obsolete_files_period_micros : int opt_name
  | Disable_auto_compactions : bool opt_name
  | Enable_write_thread_adaptive_yield : bool opt_name
  | Error_if_exists : bool opt_name
  | Hard_pending_compaction_bytes_limit : int opt_name
  | Hard_rate_limit : float opt_name
  | Info_log_level : int opt_name
  | Inplace_update_num_locks : int opt_name
  | Inplace_update_support : bool opt_name
  | Is_fd_close_on_exec : bool opt_name
  | Keep_log_file_num : int opt_name
  | Level0_file_num_compaction_trigger : int opt_name
  | Level0_slowdown_writes_trigger : int opt_name
  | Level0_stop_writes_trigger : int opt_name
  | Level_compaction_dynamic_level_bytes : bool opt_name
  | Log_file_time_to_roll : int opt_name
  | Manifest_preallocation_size : int opt_name
  | Max_background_compactions : int opt_name
  | Max_background_flushes : int opt_name
  | Max_bytes_for_level_base : int opt_name
  | Max_bytes_for_level_multiplier : float opt_name
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
  | Min_write_buffer_number_to_merge : int opt_name
  | Num_levels : int opt_name
  | Optimize_filters_for_hits : bool opt_name
  | Paranoid_checks : bool opt_name
  | Rate_limit_delay_max_milliseconds : int opt_name
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
  | Use_adaptive_mutex : bool opt_name
  | Use_direct_io_for_flush_and_compaction : bool opt_name
  | Use_direct_reads : bool opt_name
  | Use_fsync : bool opt_name
  | Wal_bytes_per_sync : int opt_name
  | Wal_recovery_mode : int opt_name
  | Writable_file_max_buffer_size : int opt_name
  | Write_buffer_size : int opt_name
  external create : unit -> t = "caml_rocksdb_Options_create"
  external set : t -> 'a opt_name -> 'a -> unit
    = "caml_rocksdb_Options_set" [@@noalloc]
  val default : t
end

module ReadOptions : sig
  type t
  type _ opt_name =
    Background_purge_on_iterator_cleanup : bool opt_name
  | Fill_cache : bool opt_name
  | Ignore_range_deletions : bool opt_name
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
  external set : t -> 'a opt_name -> 'a -> unit
    = "caml_rocksdb_ReadOptions_create" [@@noalloc]
  val default : t
end

module WriteOptions : sig
  type t
  type _ opt_name =
    DisableWAL : bool opt_name
  | Ignore_missing_column_families : bool opt_name
  | Low_pri : bool opt_name
  | No_slowdown : bool opt_name
  | Sync : bool opt_name
  external create : unit -> t = "caml_rocksdb_WriteOptions_create"
  external set : t -> 'a opt_name -> 'a -> unit
    = "caml_rocksdb_WriteOptions_set" [@@noalloc]
  val default : t
end

module FlushOptions : sig
  type t
  type _ opt_name = Wait : bool opt_name
  external create : unit -> t = "caml_rocksdb_FlushOptions_create"
  external set : t -> 'a opt_name -> 'a -> unit
    = "caml_rocksdb_FlushOptions_set" [@@noalloc]
  val default : t
end

module TransactionOptions : sig
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
  val default : t
end

module TransactionDBOptions : sig
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
  val default : t
end

module WriteBatch : sig
  type t
  external create : unit -> t = "caml_rocksdb_WriteBatch_create"
  external clear : t -> unit = "caml_rocksdb_WriteBatch_Clear" [@@noalloc]
  external count : t -> unit = "caml_rocksdb_WriteBatch_Count" [@@noalloc]
  external data : t -> string = "caml_rocksdb_WriteBatch_Data" [@@noalloc]
  external delete : t -> string -> unit = "caml_rocksdb_WriteBatch_Delete"
                                            [@@noalloc]
  external delete_range : t -> string -> string -> unit
    = "caml_rocksdb_WriteBatch_DeleteRange" [@@noalloc]
  external merge : t -> string -> string -> unit
    = "caml_rocksdb_WriteBatch_Merge" [@@noalloc]
  external pop_savepoint : t -> unit
    = "caml_rocksdb_WriteBatch_PopSavePoint" [@@noalloc]
  external put : t -> string -> string -> unit
    = "caml_rocksdb_WriteBatch_Put" [@@noalloc]
  external put_log_data : t -> string -> unit
    = "caml_rocksdb_WriteBatch_PutLogData" [@@noalloc]
  external rollback_to_savepoint : t -> unit
    = "caml_rocksdb_WriteBatch_RollbackToSavePoint" [@@noalloc]
  external set_savepoint : t -> unit
    = "caml_rocksdb_WriteBatch_SetSavePoint" [@@noalloc]
  external destroy : t -> unit =
    "caml_rocksdb_WriteBatch_destroy" [@@noalloc]
  val with_t : f:(t -> 'a) -> 'a
end

module Iterator : sig
  type t
  external is_valid : t -> bool = "caml_rocksdb_Iterator_Valid" [@@noalloc]
  external seek_to_first : t -> unit = "caml_rocksdb_Iterator_SeekToFirst"
                                         [@@noalloc]
  external seek_to_last : t -> unit = "caml_rocksdb_Iterator_SeekToLast"
                                        [@@noalloc]
  external seek : t -> string -> unit = "caml_rocksdb_Iterator_Seek"
                                          [@@noalloc]
  external seek_for_prev : t -> string
    = "caml_rocksdb_Iterator_SeekForPrev" [@@noalloc]
  external next : t -> unit = "caml_rocksdb_Iterator_Next" [@@noalloc]
  external prev : t -> unit = "caml_rocksdb_Iterator_Prev" [@@noalloc]
  external key : t -> string = "caml_rocksdb_Iterator_Key"
  external value : t -> string = "caml_rocksdb_Iterator_Value"
  external error : t -> string option = "caml_rocksdb_Iterator_Status"
  external destroy : t -> unit = "caml_rocksdb_Iterator_destroy" [@@noalloc]
end

module DB : sig
  type t
  val open_db : ?options:Options.t -> string -> t
  val open_db_for_readonly : ?options:Options.t -> ?error_if_log_file_exist:bool -> string -> t
  val flush : ?flushoptions:FlushOptions.t -> t -> unit
  external close : t -> unit = "caml_rocksdb_close"
  val get : t -> ?read_options:ReadOptions.t -> string -> string
  val put : t -> ?read_options:ReadOptions.t -> string -> string -> unit
  val delete : t -> ?read_options:ReadOptions.t -> string -> unit
  val merge : t -> ?read_options:ReadOptions.t -> string -> string -> unit
  val write : t -> ?write_options:WriteOptions.t -> WriteBatch.t -> unit
  val create_iterator : ?read_options:ReadOptions.t -> t -> Iterator.t
  val with_iterator : ?read_options:ReadOptions.t -> t ->
                      f:(Iterator.t -> 'a) -> 'a
  external create_snapshot : t -> Snapshot.t = "caml_rocksdb_GetSnapshot"
  external release_snapshot : t -> Snapshot.t -> unit
    = "caml_rocksdb_ReleaseSnapshot"
  external create_checkpoint : t -> string -> int -> unit
    = "caml_rocksdb_CreateCheckpoint"
  external get_property : t -> string -> string = "caml_rocksdb_GetProperty"
end

module ReadOnlyDB : sig
  type t
  val open_db : ?options:Options.t -> ?error_if_log_file_exist:bool
                -> string -> t
  external close : t -> unit = "caml_rocksdb_close"
  val get : t -> ?read_options:ReadOptions.t -> string -> string
  val create_iterator : ?read_options:ReadOptions.t -> t -> Iterator.t
  val with_iterator : ?read_options:ReadOptions.t -> t ->
                      f:(Iterator.t -> 'a) -> 'a
  external get_property : t -> string -> string = "caml_rocksdb_GetProperty"
end

module Transaction : sig
  type t
  external set_snapshot : t -> unit
    = "caml_rocksdb_Transaction_SetSnapshot" [@@noalloc]
  external get_snapshot : t -> Snapshot.t
    = "caml_rocksdb_Transaction_GetSnapshot"
  external clear_snapshot : t -> unit
    = "caml_rocksdb_Transaction_ClearSnapshot" [@@noalloc]
  external prepare : t -> unit = "caml_rocksdb_Transaction_Prepare"
  external commit : t -> unit = "caml_rocksdb_Transaction_Commit"
  external rollback : t -> unit = "caml_rocksdb_Transaction_Rollback"
  external set_savepoint : t -> unit
    = "caml_rocksdb_Transaction_SetSavePoint"
  external rollback_to_savepoint : t -> unit
    = "caml_rocksdb_Transaction_RollbackToSavePoint"
  val get : t -> ?read_options:ReadOptions.t -> string -> string
  val get_for_update : t -> ?read_options:ReadOptions.t -> string -> string
  val get_iterator : ?read_options:ReadOptions.t -> t -> Iterator.t
  val with_iterator : ?read_options:ReadOptions.t -> t ->
                      f:(Iterator.t -> 'a) -> 'a
  external put : t -> string -> string -> unit
    = "caml_rocksdb_Transaction_Put" [@@noalloc]
  external put_log_data : t -> string -> unit
    = "caml_rocksdb_Transaction_PutLogData" [@@noalloc]
  external delete : t -> string -> unit
    = "caml_rocksdb_Transaction_Delete" [@@noalloc]
  external merge : t -> string -> string -> unit
    = "caml_rocksdb_Transaction_Merge" [@@noalloc]
  external destroy : t -> unit = "caml_rocksdb_Transaction_destroy" [@@noalloc]
end

module TransactionDB : sig
  type t
  val flush : ?flushoptions:FlushOptions.t -> t -> unit
  external close : t -> unit = "caml_rocksdb_close"
  val get : t -> ?read_options:ReadOptions.t -> string -> string
  val put : t -> ?read_options:ReadOptions.t -> string -> string -> unit
  val delete : t -> ?read_options:ReadOptions.t -> string -> unit
  val merge : t -> ?read_options:ReadOptions.t -> string -> string -> unit
  val write : t -> ?write_options:WriteOptions.t -> WriteBatch.t -> unit
  val create_iterator : ?read_options:ReadOptions.t -> t -> Iterator.t
  val with_iterator : ?read_options:ReadOptions.t -> t ->
                      f:(Iterator.t -> 'a) -> 'a
  external create_snapshot : t -> Snapshot.t = "caml_rocksdb_GetSnapshot"
  external release_snapshot : t -> Snapshot.t -> unit
    = "caml_rocksdb_ReleaseSnapshot"
  external create_checkpoint : t -> string -> int -> unit
    = "caml_rocksdb_CreateCheckpoint"
  val open_db :
    ?options:Options.t ->
    ?transaction_db_options:TransactionDBOptions.t -> string -> t

  val begin_transaction :
    ?write_options:WriteOptions.t -> ?transaction_options:TransactionOptions.t ->
    t -> Transaction.t
  external get_property : t -> string -> string = "caml_rocksdb_GetProperty"
end
