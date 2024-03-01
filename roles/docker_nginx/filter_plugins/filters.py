class FilterModule:  # pylint: disable=too-few-public-methods
    def filters(self):  # pylint: disable=no-self-use
        return {
            "process_frontend_nets": lambda x: {y: {"external": True, "name": y} for y in x}
        }
