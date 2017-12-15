module main::config::Config

// Projects
private loc example = |project://example|;
private loc example_piotr = |project://example_piotr|;
private loc hsql = |project://hsqldb-2.3.1|;
private loc smallSql = |project://smallsql0.21_src|;

public loc CURRENT_PROJECT = smallSql;

// Duplication
public int WINDOW_SIZE = 6;
public bool COUNT_ORIGINALS = false;

public bool WITH_TIMER = true;