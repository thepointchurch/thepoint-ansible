class FilterModule(object):
    def filters(self):
        return {'process_frontend_nets': lambda x: {y: {'external': {'name': y}} for y in x}}
