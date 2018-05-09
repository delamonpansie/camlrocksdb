#include <stdio.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/custom.h>
#include <caml/fail.h>
#include <caml/threads.h>


#include "rocksdb/db.h"
#include "rocksdb/options.h"
#include "rocksdb/status.h"
#include "rocksdb/table.h"
#include "rocksdb/iterator.h"
#include "rocksdb/utilities/checkpoint.h"
#include "rocksdb/utilities/transaction.h"
#include "rocksdb/utilities/transaction_db.h"
#include "rocksdb/utilities/stackable_db.h"

using rocksdb::DB;
using rocksdb::Options;
using rocksdb::ReadOptions;
using rocksdb::WriteOptions;
using rocksdb::FlushOptions;
using rocksdb::TransactionOptions;
using rocksdb::TransactionDBOptions;
using rocksdb::Status;
using rocksdb::InfoLogLevel;
using rocksdb::WALRecoveryMode;
using rocksdb::Slice;
using rocksdb::SliceParts;
using rocksdb::Iterator;
using rocksdb::WriteBatch;
using rocksdb::Snapshot;
using rocksdb::Checkpoint;
using rocksdb::Transaction;
using rocksdb::TransactionDB;
using rocksdb::TxnDBWritePolicy;

extern "C" {

void check_status(const Status &s) {
	if (s.ok())
		return;
	if (s.IsNotFound())
		caml_raise_not_found();
	caml_failwith(s.ToString().c_str());
}


#define Define(name)							\
static struct custom_operations op_##name##_t;				\
static void caml_rocksdb_##name##_finalize(value v) {			\
	auto ptr = *(name **)Data_custom_val(v);			\
	delete ptr;							\
}									\
value caml_rocksdb_##name##_destroy(value v) {			\
	auto ptr = *(name **)Data_custom_val(v);			\
	*(void **)Data_custom_val(v) = nullptr;				\
	delete ptr;							\
	return Val_unit;						\
}									\
static void __attribute__((__constructor__)) caml_rocksdb_##name##_init() { \
	op_##name##_t.identifier = (char *)"caml_rocksdb_" #name;	\
	op_##name##_t.finalize = caml_rocksdb_##name##_finalize;	\
}

#define Define_with_create(name)					\
Define(name)								\
value caml_rocksdb_##name##_create(value unit) {			\
	value v = caml_alloc_custom(&op_##name##_t, sizeof(name *), 0, 1);\
	*(name **)Data_custom_val(v) = new name();			\
	return v;							\
}



#define StdString_val(v) std::string(String_val(v), caml_string_length(v))
#define Slice_val(v) Slice(String_val(v), caml_string_length(v))

#define Options_val(v) (*(Options **)Data_custom_val(v))
#define ReadOptions_val(v) (*(ReadOptions **)Data_custom_val(v))
#define WriteOptions_val(v) (*(WriteOptions **)Data_custom_val(v))
#define FlushOptions_val(v) (*(FlushOptions **)Data_custom_val(v))
#define TransactionOptions_val(v) (*(TransactionOptions **)Data_custom_val(v))
#define TransactionDBOptions_val(v) (*(TransactionDBOptions **)Data_custom_val(v))
#define WriteBatch_val(v) (*(WriteBatch **)Data_custom_val(v))
#define Iterator_val(v) (*(Iterator **)Data_custom_val(v))
#define Snapshot_val(v) (*(const Snapshot **)Data_custom_val(v))
#define Transaction_val(v) (*(Transaction **)Data_custom_val(v))
#define DB_val(v) (*(DB **)Data_custom_val(v))
#define TransactionDB_val(v) (*(TransactionDB **)Data_custom_val(v))

Define_with_create(Options)
Define_with_create(ReadOptions)
Define_with_create(WriteOptions)
Define_with_create(FlushOptions)
Define_with_create(TransactionOptions)
Define_with_create(TransactionDBOptions)
Define_with_create(WriteBatch)
Define(Iterator)
Define(Transaction)

value caml_rocksdb_Options_set(value rep, value o, value v) {
	auto opt = Options_val(rep);

	switch (Int_val(o)) {
	case 0: opt->WAL_size_limit_MB = Int_val(v); break;
	case 1: opt->WAL_ttl_seconds = Int_val(v); break;
	//access_hint_on_compaction_start
	case 2: opt->advise_random_on_open = Bool_val(v); break;
	case 3: opt->allow_concurrent_memtable_write = Bool_val(v); break;
	case 4: opt->allow_mmap_reads = Bool_val(v); break;
	case 5: opt->allow_mmap_writes = Bool_val(v); break;
	case 6: opt->arena_block_size = Int_val(v); break;
	case 7: opt->base_background_compactions = Int_val(v); break;
	//block_based_table_factory
	case 8: opt->bloom_locality = Int_val(v); break;
	//compaction_filter
	//compaction_filter_factory
	//compaction_style
	//comparator
	//compression
	//compression_options
	//compression_per_level
	case 9: opt->create_if_missing = Bool_val(v); break;
	case 10: opt->create_missing_column_families = Bool_val(v); break;
	//cuckoo_table_factory
	case 11: opt->db_log_dir = StdString_val(v); break;
	//db_paths
	case 12: opt->db_write_buffer_size = Int_val(v); break;
	case 13: opt->delete_obsolete_files_period_micros = Int_val(v); break;
	case 14: opt->disable_auto_compactions = Bool_val(v); break; // ??
	case 15: opt->enable_write_thread_adaptive_yield = Bool_val(v); break;
	//env
	case 16: opt->error_if_exists = Bool_val(v); break;
	//fifo_compaction_options
	case 17: opt->hard_pending_compaction_bytes_limit = Int_val(v); break;
	case 18: opt->hard_rate_limit = Double_val(v); break;
	//hash_link_list_rep
	//hash_skip_list_rep
	//info_log
	case 19: opt->info_log_level = static_cast<InfoLogLevel>Int_val(v); break;
	case 20: opt->inplace_update_num_locks = Int_val(v); break;
	case 21: opt->inplace_update_support = Bool_val(v); break;
	case 22: opt->is_fd_close_on_exec = Bool_val(v); break;
	case 23: opt->keep_log_file_num = Int_val(v); break;
	case 24: opt->level0_file_num_compaction_trigger = Int_val(v); break;
	case 25: opt->level0_slowdown_writes_trigger = Int_val(v); break;
	case 26: opt->level0_stop_writes_trigger = Int_val(v); break;
	case 27: opt->level_compaction_dynamic_level_bytes = Bool_val(v); break; // ?
	case 28: opt->log_file_time_to_roll = Int_val(v); break;
	case 29: opt->manifest_preallocation_size = Int_val(v); break;
	case 30: opt->max_background_compactions = Int_val(v); break;
	case 31: opt->max_background_flushes = Int_val(v); break;
	case 32: opt->max_bytes_for_level_base = Int_val(v); break;
	case 33: opt->max_bytes_for_level_multiplier = Double_val(v); break;
	//max_bytes_for_level_multiplier_additional
	case 34: opt->max_compaction_bytes = Int_val(v); break;
	case 35: opt->max_file_opening_threads = Int_val(v); break;
	case 36: opt->max_log_file_size = Int_val(v); break;
	case 37: opt->max_manifest_file_size = Int_val(v); break;
	case 38: opt->max_mem_compaction_level = Int_val(v); break;
	case 39: opt->max_open_files = Int_val(v); break;
	case 40: opt->max_sequential_skip_in_iterations = Int_val(v); break;
	case 41: opt->max_successive_merges = Int_val(v); break;
	case 42: opt->max_total_wal_size = Int_val(v); break;
	case 43: opt->max_write_buffer_number = Int_val(v); break;
	case 44: opt->max_write_buffer_number_to_maintain = Int_val(v); break;
	case 45: opt->memtable_huge_page_size = Int_val(v); break;
	case 46: opt->memtable_prefix_bloom_size_ratio = Double_val(v); break;
	//memtable_vector_rep
	//merge_operator
	//min_level_to_compress
	case 47: opt->min_write_buffer_number_to_merge = Int_val(v); break;
	case 48: opt->num_levels = Int_val(v); break;
	case 49: opt->optimize_filters_for_hits = Bool_val(v); break;
	case 50: opt->paranoid_checks = Bool_val(v); break;
	//plain_table_factory
	//prefix_extractor
	case 51: opt->rate_limit_delay_max_milliseconds = Int_val(v); break;
	//ratelimiter
	case 52: opt->recycle_log_file_num = Int_val(v); break;
	case 53: opt->report_bg_io_stats = Bool_val(v); break;
	case 54: opt->skip_log_error_on_recovery = Bool_val(v); break;
	case 55: opt->skip_stats_update_on_db_open = Bool_val(v); break;
	case 56: opt->soft_pending_compaction_bytes_limit = Int_val(v); break;
	case 57: opt->soft_rate_limit = Double_val(v); break;
	case 58: opt->stats_dump_period_sec = Int_val(v); break;
	case 59: opt->table_cache_numshardbits = Int_val(v); break;
	case 60: opt->target_file_size_base = Int_val(v); break;
	case 61: opt->target_file_size_multiplier = Int_val(v); break;
	//uint64add_merge_operator
	case 62: opt->use_adaptive_mutex = Bool_val(v); break;
	case 63: opt->use_direct_io_for_flush_and_compaction = Bool_val(v); break;
	case 64: opt->use_direct_reads = Bool_val(v); break;
	case 65: opt->use_fsync = Bool_val(v); break;
	case 66: opt->wal_bytes_per_sync = Int_val(v); break;
	//wal_dir
	case 67: opt->wal_recovery_mode = static_cast<WALRecoveryMode>(Int_val(v)); break;
	case 68: opt->writable_file_max_buffer_size = Int_val(v); break;
	case 69: opt->write_buffer_size = Int_val(v); break;
	//rocksdb_options_increase_parallelism
	//rocksdb_options_optimize_for_point_lookup
	//rocksdb_options_optimize_level_style_compaction
	//rocksdb_options_optimize_universal_style_compaction
	default:
		assert(false);
	}
	return Val_unit;
}

value caml_rocksdb_ReadOptions_set(value rep, value o, value v) {
	auto opt = ReadOptions_val(rep);

	switch (Int_val(o)) {
	case 0: opt->background_purge_on_iterator_cleanup = Bool_val(v); break;
	case 1: opt->fill_cache = Bool_val(v); break;
	case 2: opt->ignore_range_deletions = Bool_val(v); break;
	//iterate_lower_bound
	//iterate_upper_bound
	case 3: opt->managed = Bool_val(v); break;
	case 4: opt->max_skippable_internal_keys = Int_val(v); break;
	case 5: opt->pin_data = Bool_val(v); break;
	case 6: opt->prefix_same_as_start = Bool_val(v); break;
	case 7: opt->readahead_size = Int_val(v); break;
	case 8: opt->read_tier = static_cast<rocksdb::ReadTier>(Int_val(v)); break;
	case 9: opt->snapshot = (Is_long(v) ? nullptr : Snapshot_val(Field(v, 0))); break;
	case 10: opt->tailing = Bool_val(v); break;
	case 11: opt->total_order_seek = Bool_val(v); break;
	case 12: opt->verify_checksums = Bool_val(v); break;
	default:
		assert(false);
	}
	return Val_unit;
}

value caml_rocksdb_WriteOptions_set(value rep, value o, value v) {
	auto opt = WriteOptions_val(rep);

	switch (Int_val(o)) {
	case 0: opt->disableWAL= Bool_val(v); break;
	case 1: opt->ignore_missing_column_families = Bool_val(v); break;
	case 2: opt->low_pri = Bool_val(v); break;
	case 3: opt->no_slowdown = Bool_val(v); break;
	case 4: opt->sync = Bool_val(v); break;
	default:
		assert(false);
	}
	return Val_unit;
}


value caml_rocksdb_FlushOptions_set(value rep, value o, value v) {
	auto opt = FlushOptions_val(rep);

	switch (Int_val(o)) {
	case 0: opt->wait= Bool_val(v); break;
	default:
		assert(false);
	}
	return Val_unit;
}

value caml_rocksdb_TransactionOptions_set(value rep, value o, value v) {
	auto opt = TransactionOptions_val(rep);

	switch (Int_val(o)) {
	case 0: opt->set_snapshot = Bool_val(v); break;
	case 1: opt->deadlock_detect = Bool_val(v); break;
	case 2: opt->use_only_the_last_commit_time_batch_for_recovery = Bool_val(v); break;
	case 3: opt->lock_timeout = Int_val(v); break;
	case 4: opt->expiration = Int_val(v); break;
	case 5: opt->deadlock_detect_depth = Int_val(v); break;
	case 6: opt->max_write_batch_size = Int_val(v);
	default:
		assert(false);
	}
	return Val_unit;
}

value caml_rocksdb_TransactionDBOptions_set(value rep, value o, value v) {
	auto opt = TransactionDBOptions_val(rep);

	switch (Int_val(o)) {
	case 0: opt->max_num_locks = Int_val(v); break;
	case 1: opt->max_num_deadlocks = Int_val(v); break;
	case 2: opt->num_stripes = Int_val(v); break;
	case 3: opt->transaction_lock_timeout = Int_val(v); break;
	case 4: opt->default_lock_timeout = Int_val(v); break;
	case 5: switch(Int_val(v)) {
		case 0: opt->write_policy = TxnDBWritePolicy::WRITE_COMMITTED;
			break;
		case 1: opt->write_policy = TxnDBWritePolicy::WRITE_PREPARED;
			break;
		case 2: opt->write_policy = TxnDBWritePolicy::WRITE_UNPREPARED;
			break;
		default:
			assert(false);
		}
	default:
		assert(false);
	}
	return Val_unit;
}

value caml_rocksdb_WriteBatch_Clear(value batch) {
	WriteBatch_val(batch)->Clear();
	return Val_unit;
}

value caml_rocksdb_WriteBatch_Count(value batch) {
	return Val_int(WriteBatch_val(batch)->Count());
}

value caml_rocksdb_WriteBatch_Data(value batch) {
	auto data = WriteBatch_val(batch)->Data();
	return caml_alloc_initialized_string(data.length(), data.c_str());
}

value caml_rocksdb_WriteBatch_Delete(value batch, value key) {
	WriteBatch_val(batch)->Delete(Slice_val(key));
	return Val_unit;
}

value caml_rocksdb_WriteBatch_DeleteRange(value batch, value start_key, value end_key) {
	WriteBatch_val(batch)->DeleteRange(Slice_val(start_key), Slice_val(end_key));
	return Val_unit;
}

value caml_rocksdb_WriteBatch_Merge(value batch, value key, value val) {
	WriteBatch_val(batch)->Merge(Slice_val(key), Slice_val(val));
	return Val_unit;
}

value caml_rocksdb_WriteBatch_PopSavePoint(value batch) {
	auto s = WriteBatch_val(batch)->PopSavePoint();
	check_status(s);
	return Val_unit;
}

value caml_rocksdb_WriteBatch_Put(value batch, value key, value val) {
	WriteBatch_val(batch)->Put(Slice_val(key), Slice_val(val));
	return Val_unit;
}

value caml_rocksdb_WriteBatch_PutLogData(value batch, value blob) {
	WriteBatch_val(batch)->PutLogData(Slice_val(blob));
	return Val_unit;
}

value caml_rocksdb_WriteBatch_RollbackToSavePoint(value batch) {
	auto s = WriteBatch_val(batch)->RollbackToSavePoint();
	check_status(s);
	return Val_unit;
}

value caml_rocksdb_WriteBatch_SetSavePoint(value batch) {
	WriteBatch_val(batch)->SetSavePoint();
	return Val_unit;
}

static struct custom_operations op_t;

static void caml_rocksdb_finalize (value v) {
	auto db = *(DB **)Data_custom_val(v);
	*(void **)Data_custom_val(v) = nullptr;
	delete db;
}

static void __attribute__((__constructor__)) caml_rocksdb_init() {
	op_t.identifier = (char *)"caml_rocksdb_DB";
	op_t.finalize = caml_rocksdb_finalize;
}


value caml_rocksdb_Open(value options_val, value name_val) {
	auto name = StdString_val(name_val);
	auto options = Options_val(options_val);
	caml_enter_blocking_section();
	DB *db;
	auto s = DB::Open(*options, name, &db);
	caml_leave_blocking_section();
	check_status(s);
	value db_val = caml_alloc_custom(&op_t, sizeof(DB *), 0, 1);
	DB_val(db_val) = db;
	return db_val;
}

value caml_rocksdb_OpenForReadOnly(value options_val, value name_val, value error_if_log_file_exist) {
	auto name = StdString_val(name_val);
	auto options = Options_val(options_val);
	caml_enter_blocking_section();
	DB *db;
	auto s = DB::OpenForReadOnly(*options, name, &db, Bool_val(error_if_log_file_exist));
	caml_leave_blocking_section();
	check_status(s);
	value db_val = caml_alloc_custom(&op_t, sizeof(DB *), 0, 1);
	DB_val(db_val) = db;
	return db_val;
}

value caml_rocksdb_close(value db_val) {
	CAMLparam1(db_val);
	auto db = DB_val(db_val);
	caml_enter_blocking_section();
	delete db;
	caml_leave_blocking_section();
	DB_val(db_val) = nullptr;
	CAMLreturn(Val_unit);
}

value caml_rocksdb_Flush(value db_val, value options_val) {
	auto db = DB_val(db_val);
	auto options = FlushOptions_val(options_val);
	caml_enter_blocking_section();
	auto s = db->Flush(*options);
	caml_leave_blocking_section();
	check_status(s);
	return Val_unit;
}

value caml_rocksdb_Get(value db_val, value options_val, value key_val) {
	auto db = DB_val(db_val);
	auto options = ReadOptions_val(options_val);
	auto key = StdString_val(key_val);
	std::string val;
	caml_enter_blocking_section();
	auto s = db->Get(*options, key, &val);
	caml_leave_blocking_section();
	check_status(s);
	return caml_alloc_initialized_string(val.length(), val.c_str());
}

value caml_rocksdb_Put(value db_val, value options_val, value key_val, value value_val) {
	auto db = DB_val(db_val);
	auto options = WriteOptions_val(options_val);
	auto key = StdString_val(key_val);
	auto value = StdString_val(value_val);
	caml_enter_blocking_section();
	auto s = db->Put(*options, key, value);
	caml_leave_blocking_section();
	check_status(s);
	return Val_unit;
}

value caml_rocksdb_Delete(value db_val, value options_val, value key_val) {
	auto db = DB_val(db_val);
	auto options = WriteOptions_val(options_val);
	auto key = StdString_val(key_val);
	caml_enter_blocking_section();
	auto s = db->Delete(*options, key);
	caml_leave_blocking_section();
	check_status(s);
	return Val_unit;
}

value caml_rocksdb_Merge(value db_val, value options_val, value key_val, value value_val) {
	auto db = DB_val(db_val);
	auto options = WriteOptions_val(options_val);
	auto key = StdString_val(key_val);
	auto value = StdString_val(value_val);
	caml_enter_blocking_section();
	auto s = db->Merge(*options, key, value);
	caml_leave_blocking_section();
	check_status(s);
	return Val_unit;
}

value caml_rocksdb_Write(value db_val, value options_val, value batch_val) {
	auto db = DB_val(db_val);
	auto options = WriteOptions_val(options_val);
	auto batch = WriteBatch_val(batch_val);
	caml_enter_blocking_section();
	auto s = db->Write(*options, batch);
	caml_leave_blocking_section();
	check_status(s);
	return Val_unit;
}

value caml_rocksdb_GetProperty(value db_val, value property_val) {
	auto db = DB_val(db_val);
	auto property = StdString_val(property_val);
	std::string val;
	if (!db->GetProperty(property, &val))
		caml_invalid_argument("Rocksdb.DB.get_property");
	return caml_alloc_initialized_string(val.length(), val.c_str());
}

value caml_rocksdb_NewIterator(value db_val, value options_val) {
	auto db = DB_val(db_val);
	auto options = ReadOptions_val(options_val);
	value iter = caml_alloc_custom(&op_Iterator_t, sizeof(Iterator *), 0, 1);
	Iterator_val(iter) = db->NewIterator(*options);
	return iter;
}

value caml_rocksdb_Iterator_Valid(value v) {
	return Val_bool(Iterator_val(v)->Valid());
}

value caml_rocksdb_Iterator_SeekToFirst(value v) {
	auto iter = Iterator_val(v);
	caml_enter_blocking_section();
	iter->SeekToFirst();
	caml_leave_blocking_section();
	return Val_unit;
}

value caml_rocksdb_Iterator_SeekToLast(value v) {
	auto iter = Iterator_val(v);
	caml_enter_blocking_section();
	iter->SeekToLast();
	caml_leave_blocking_section();
	return Val_unit;
}

value caml_rocksdb_Iterator_Seek(value v, value key_val) {
	auto iter = Iterator_val(v);
	auto key = StdString_val(key_val);
	caml_enter_blocking_section();
	iter->Seek(key);
	caml_leave_blocking_section();
	return Val_unit;
}

value caml_rocksdb_Iterator_SeekForPrev(value v, value key_val) {
	auto iter = Iterator_val(v);
	auto key = StdString_val(key_val);
	caml_enter_blocking_section();
	iter->SeekForPrev(key);
	caml_leave_blocking_section();
	return Val_unit;
}

value caml_rocksdb_Iterator_Next(value v) {
	auto iter = Iterator_val(v);
	caml_enter_blocking_section();
	iter->Next();
	caml_leave_blocking_section();
	return Val_unit;
}

value caml_rocksdb_Iterator_Prev(value v) {
	auto iter = Iterator_val(v);
	caml_enter_blocking_section();
	iter->Prev();
	caml_leave_blocking_section();
	return Val_unit;
}

value caml_rocksdb_Iterator_Key(value v) {
	auto iter = Iterator_val(v);
	caml_enter_blocking_section();
	auto s = iter->key();
	caml_leave_blocking_section();
	return caml_alloc_initialized_string(s.size(), s.data());
}

value caml_rocksdb_Iterator_Value(value v) {
	auto s = Iterator_val(v)->value();
	return caml_alloc_initialized_string(s.size(), s.data());
}

value caml_rocksdb_Iterator_Status(value v) {
	CAMLparam1(v);
	CAMLlocal2(some, str);

	auto status = Iterator_val(v)->status();
	if (status.ok())
		return Val_int(0);

	auto s = status.ToString();
	str = caml_alloc_initialized_string(s.length(), s.c_str());
	some = caml_alloc(1, 0);
	Store_field(some, 0, str);
	CAMLreturn(some);
}

static struct custom_operations op_Snapshot_t;
void caml_rocksdb_Snapshot_finalize(value v) {
	auto snapshot = *(Snapshot **)Data_custom_val(v);
	assert(snapshot == nullptr);
}
static void __attribute__((__constructor__)) caml_rocksdb_Snapshot_init() {
	op_Snapshot_t.identifier = (char *)"caml_rocksdb_Snapshot";
	op_Snapshot_t.finalize = caml_rocksdb_Snapshot_finalize;
}

value caml_rocksdb_GetSnapshot(value db) {
	CAMLparam1(db);
	CAMLlocal1(ret);
	auto snap = DB_val(db)->GetSnapshot();
	if (snap == nullptr)
		caml_failwith("create_snaphot");
	ret = caml_alloc_custom(&op_Snapshot_t, sizeof(Snapshot *), 0, 1);
	Snapshot_val(ret) = snap;
	CAMLreturn(ret);
}

value caml_rocksdb_ReleaseSnapshot(value db, value v) {
	DB_val(db)->ReleaseSnapshot(Snapshot_val(v));
	return Val_unit;
}

value caml_rocksdb_CreateCheckpoint(value db, value dir,
					       value log_size_for_flush) {
	Checkpoint *checkpoint;
	auto s = Checkpoint::Create(DB_val(db), &checkpoint);
	check_status(s);
	s = checkpoint->CreateCheckpoint(StdString_val(dir),
					 Int_val(log_size_for_flush));
	delete checkpoint;
	check_status(s);
	return Val_unit;
}

value caml_rocksdb_Transaction_SetSnapshot(value txn) {
	Transaction_val(txn)->SetSnapshot();
	return Val_unit;
}

value caml_rocksdb_Transaction_GetSnapshot(value txn) {
	CAMLparam1(txn);
	CAMLlocal1(ret);
	auto snap = Transaction_val(txn)->GetSnapshot();
	if (snap == nullptr)
		caml_failwith("get_snaphot");
	ret = caml_alloc_custom(&op_Snapshot_t, sizeof(Snapshot *), 0, 1);
	Snapshot_val(ret) = snap;
	CAMLreturn(ret);
}

value caml_rocksdb_Transaction_ClearSnapshot(value txn) {
	Transaction_val(txn)->ClearSnapshot();
	return Val_unit;
}

value caml_rocksdb_Transaction_Delete(value txn, value key) {
	Transaction_val(txn)->Delete(Slice_val(key));
	return Val_unit;
}

value caml_rocksdb_Transaction_Merge(value txn, value key, value val) {
	Transaction_val(txn)->Merge(Slice_val(key), Slice_val(val));
	return Val_unit;
}

value caml_rocksdb_Transaction_Put(value txn, value key, value val) {
	Transaction_val(txn)->Put(Slice_val(key), Slice_val(val));
	return Val_unit;
}

value caml_rocksdb_Transaction_PutLogData(value txn, value blob) {
	Transaction_val(txn)->PutLogData(Slice_val(blob));
	return Val_unit;
}

value caml_rocksdb_Transaction_RollbackToSavePoint(value txn) {
	auto s = Transaction_val(txn)->RollbackToSavePoint();
	check_status(s);
	return Val_unit;
}

value caml_rocksdb_Transaction_SetSavePoint(value txn) {
	Transaction_val(txn)->SetSavePoint();
	return Val_unit;
}

value caml_rocksdb_Transaction_Get(value txn_val, value options_val, value key_val) {
	auto txn = Transaction_val(txn_val);
	auto options = ReadOptions_val(options_val);
	auto key = StdString_val(key_val);
	std::string val;
	caml_enter_blocking_section();
	auto s = txn->Get(*options, key, &val);
	caml_leave_blocking_section();
	check_status(s);
	return caml_alloc_initialized_string(val.length(), val.c_str());
}

value caml_rocksdb_Transaction_GetForUpdate(value txn_val, value options_val, value key_val, value exclusive) {
	auto txn = Transaction_val(txn_val);
	auto options = ReadOptions_val(options_val);
	auto key = StdString_val(key_val);
	std::string val;
	caml_enter_blocking_section();
	auto s = txn->GetForUpdate(*options, key, &val, Bool_val(exclusive));
	caml_leave_blocking_section();
	check_status(s);
	return caml_alloc_initialized_string(val.length(), val.c_str());
}

value caml_rocksdb_Transaction_GetIterator(value txn_val, value options_val) {
	auto txn = Transaction_val(txn_val);
	auto options = ReadOptions_val(options_val);
	value iter = caml_alloc_custom(&op_Iterator_t, sizeof(Iterator *), 0, 1);
	Iterator_val(iter) = txn->GetIterator(*options);
	return iter;
}

value caml_rocksdb_Transaction_Prepare(value txn_val) {
	auto txn = Transaction_val(txn_val);
	caml_enter_blocking_section();
	auto s = txn->Prepare();
	caml_leave_blocking_section();
	check_status(s);
	return Val_unit;
}

value caml_rocksdb_Transaction_Commit(value txn_val) {
	auto txn = Transaction_val(txn_val);
	caml_enter_blocking_section();
	auto s = txn->Commit();
	caml_leave_blocking_section();
	check_status(s);
	return Val_unit;
}

value caml_rocksdb_Transaction_Rollback(value txn_val) {
	auto txn = Transaction_val(txn_val);
	caml_enter_blocking_section();
	auto s = txn->Rollback();
	caml_leave_blocking_section();
	check_status(s);
	return Val_unit;
}
value caml_rocksdb_TransactionDB_Open(value options_val,
				      value transaction_db_options_val,
				      value name_val) {
	auto name = StdString_val(name_val);
	auto options = Options_val(options_val);
	auto transaction_db_options = TransactionDBOptions_val(transaction_db_options_val);
	caml_enter_blocking_section();
	TransactionDB *db;
	auto s = TransactionDB::Open(*options, *transaction_db_options, name, &db);
	caml_leave_blocking_section();
	check_status(s);
	value db_val = caml_alloc_custom(&op_t, sizeof(TransactionDB *), 0, 1);
	DB_val(db_val) = db;
	return db_val;
}

value caml_rocksdb_TransactionDB_BeginTrasaction(value db_val,
						 value write_options,
						 value transaction_options) {
	CAMLparam3(write_options, transaction_options, db_val);
	CAMLlocal1(txn_val);

	auto db = TransactionDB_val(db_val);
	auto txn = db->BeginTransaction(*WriteOptions_val(write_options),
					*TransactionOptions_val(transaction_options),
					nullptr);
	txn_val = caml_alloc_custom(&op_Transaction_t, sizeof(Transaction *), 0, 1);
	Transaction_val(txn_val) = txn;
	CAMLreturn(txn_val);
}

}
