module.exports = ({ env }) => ({
  defaultConnection: 'default',
  connections: {
    default: {
      connector: 'bookshelf',
      settings: {
        client: 'mysql',
        host: env('DATABASE_HOST', 'srv1.rarecamion.com'),
        port: env.int('DATABASE_PORT', 3306),
        database: env('DATABASE_NAME', 'rcadmin1_testap1'),
        username: env('DATABASE_USERNAME', 'rcadmin1_testus1'),
        password: env('DATABASE_PASSWORD', 'Rim@2022'),
        ssl: env.bool('DATABASE_SSL', true),
      },
      options: {}
    },
  },
});
