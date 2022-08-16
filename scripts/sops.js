#!/usr/bin/env zx

import { $, argv, chalk, cd, fs } from 'zx'

class Sops {
  constructor (args) {
    this.args = args
    this.action = this.args._[0]
    this.dir = this.args.dir || argv.dir || './config'
    this.yamls = fs
      .readdirSync(this.dir)
      .filter(file => file.endsWith('.yaml'))

    switch (this.action) {
      case 'encrypt':
        this.encrypt()
        break
      case 'decrypt':
        this.decrypt()
        break
      default:
        console.error('404: ' + chalk.redBright(`${this.action} arg not found`))
        break
    }
  }

  isEncrypted () {
    return this.yamls.some(file => file.includes('sops'))
  }

  async encrypt () {
    if (this.isEncrypted()) {
      return console.error(chalk.yellowBright(`Files in ${this.dir} were already encrypted`))
    }

    cd(this.dir)
    for (const file of this.yamls) {
      await $`sops -e -i ${file} && mv ${file} ${file.slice(0, -5) + '.sops.yaml'}`
    }
    console.log(chalk.greenBright(`Files in ${this.dir} have been encrypted`))
  }

  async decrypt () {
    if (!this.isEncrypted()) {
      return console.error(chalk.yellowBright(`Files in ${this.dir} were already decrypted`))
    }

    cd(this.dir)
    for (const file of this.yamls) {
      await $`sops -d -i ${file} && mv ${file} ${file.slice(0, -10) + '.yaml'}`
    }
    console.log(chalk.greenBright(`Files in ${this.dir} have been decrypted`))
  }
}

export { Sops }

$.verbose = false
const sops = new Sops(argv)
export default sops
