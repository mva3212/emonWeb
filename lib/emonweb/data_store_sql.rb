module DataStoreSql

  TIMESLOTS = [:one_min, :five_mins, :fifteen_mins, :one_hour, :four_hours, :twelve_hours]

  def create_data_store_tables(table_name)
    create_table(table_name) unless table_exist?(table_name)
    TIMESLOTS.each do |timeslot|
      name = table_name + '_' + timeslot.to_s
      create_table(name) unless table_exist?(name)
    end
  end

  private

  def table_exist?(name)
    ActiveRecord::Base.connection.execute('ROLLBACK')
    ActiveRecord::Base.connection.tables.include?(name)
  end

  def create_table(table_name)
    execute(:mysql2 => mysql2_statement(table_name), :postgresql => postgresql_statement(table_name))

    logger.info "Created a new DateStore table: #{table_name}"
  end

  def execute(statements = {})
    database = ActiveRecord::Base.connection.adapter_name
    case database
    when 'PostgreSQL'
      if statements[:postgresql]
        ActiveRecord::Base.connection.execute('ROLLBACK')
        ActiveRecord::Base.connection.execute statements[:postgresql]
      end
    when 'Mysql2'
      ActiveRecord::Base.connection.execute statements[:mysql2] if statements[:mysql2]
    else
      raise 'Database statement not implemented for #{database} adapter'
    end
  end

  def mysql2_statement(table_name)
    "CREATE TABLE `#{table_name}` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `value` float NOT NULL,
    `created_at` datetime NOT NULL,
    `updated_at` datetime NOT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB"
  end

  def postgresql_statement(table_name)
    "CREATE TABLE #{table_name} (
    id integer NOT NULL,
    value double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
    );

    CREATE SEQUENCE #{table_name}_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    ALTER SEQUENCE #{table_name}_id_seq OWNED BY #{table_name}.id;

    ALTER TABLE #{table_name} ALTER COLUMN id SET DEFAULT nextval('#{table_name}_id_seq'::regclass);

    ALTER TABLE ONLY #{table_name}
    ADD CONSTRAINT #{table_name}_pkey PRIMARY KEY (id);"
  end
end
